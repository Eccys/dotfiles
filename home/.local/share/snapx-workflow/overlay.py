#!/usr/bin/env python3
"""Interactive frozen-screen editor used by the Hyprland SnapX workflow."""
import argparse
import math
from pathlib import Path
import sys
from PySide6.QtCore import Qt, QPointF, QRectF, QTimer
from PySide6.QtGui import QColor, QFont, QImage, QPainter, QPainterPath, QPen, QPixmap, QShortcut, QKeySequence, QTransform
from PySide6.QtWidgets import (QApplication, QColorDialog, QFileDialog, QGraphicsItem,
    QGraphicsScene, QGraphicsView, QInputDialog, QLabel, QMainWindow, QMessageBox,
    QPushButton, QSpinBox, QToolBar, QStatusBar)


class Layer(QGraphicsItem):
    def __init__(self, data, changed):
        super().__init__()
        self.data = data
        self.changed = changed
        self.resizing = False
        self.setFlags(QGraphicsItem.ItemIsMovable | QGraphicsItem.ItemIsSelectable)
        self.setPos(data.get('x', 0), data.get('y', 0))
        self.setScale(data.get('scale', 1))

    def boundingRect(self):
        return QRectF(0, 0, max(1, self.data['w']), max(1, self.data['h'])).adjusted(-8, -8, 8, 8)

    def paint(self, painter, option, widget=None):
        d = self.data
        r = QRectF(0, 0, d['w'], d['h'])
        painter.setRenderHint(QPainter.Antialiasing)
        painter.setPen(QPen(QColor(d.get('color', '#ff4040')), d.get('stroke', 3), Qt.SolidLine, Qt.RoundCap, Qt.RoundJoin))
        kind = d['kind']
        if kind == 'image':
            painter.drawPixmap(r, d['pixmap'], QRectF(d['pixmap'].rect()))
        elif kind in ('rect', 'ellipse'):
            if kind == 'rect': painter.drawRect(r)
            else: painter.drawEllipse(r)
        elif kind == 'text':
            painter.setFont(QFont('DejaVu Sans', d.get('font_size', 24)))
            painter.drawText(r, Qt.AlignLeft | Qt.AlignTop, d['text'])
        else:
            points = d['points']
            path = QPainterPath(QPointF(*points[0]))
            for point in points[1:]: path.lineTo(QPointF(*point))
            painter.drawPath(path)
            if kind == 'arrow':
                a, b = QPointF(*points[0]), QPointF(*points[-1])
                angle = math.atan2(b.y()-a.y(), b.x()-a.x())
                size = 12 + d.get('stroke', 3)
                for delta in (-0.5, 0.5):
                    painter.drawLine(b, b-QPointF(math.cos(angle+delta)*size, math.sin(angle+delta)*size))
        if self.isSelected():
            pen = QPen(QColor('#70bfff'), 1, Qt.DashLine)
            pen.setCosmetic(True)
            painter.setPen(pen)
            painter.drawRect(r)
            painter.fillRect(QRectF(d['w']-6, d['h']-6, 12, 12), QColor('#70bfff'))

    def mousePressEvent(self, event):
        d = self.data
        if self.isSelected() and (event.pos()-QPointF(d['w'], d['h'])).manhattanLength() < 20:
            self.resizing = True
            self.origin = self.scenePos()
            self.start_scale = self.scale()
            event.accept()
        else:
            super().mousePressEvent(event)

    def mouseMoveEvent(self, event):
        if self.resizing:
            delta = event.scenePos()-self.origin
            value = max(delta.x()/max(1,self.data['w']), delta.y()/max(1,self.data['h']))
            self.setScale(max(0.05, min(20, value)))
            event.accept()
        else:
            super().mouseMoveEvent(event)

    def mouseReleaseEvent(self, event):
        self.resizing = False
        super().mouseReleaseEvent(event)
        self.changed()


class Canvas(QGraphicsView):
    def __init__(self, editor):
        super().__init__(editor.scene)
        self.editor = editor
        self.setAlignment(Qt.AlignLeft | Qt.AlignTop)
        self.setRenderHints(QPainter.Antialiasing | QPainter.SmoothPixmapTransform)
        self.setFrameShape(QGraphicsView.NoFrame)
        self.setMouseTracking(True)
        self.setBackgroundBrush(QColor('#17191d'))
        self.draft = None
        self.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        self.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOff)

    def resizeEvent(self,event):
        super().resizeEvent(event)
        self.sync_view()

    def sync_view(self):
        rect=self.editor.scene.sceneRect()
        if rect.width() and rect.height():
            self.setTransform(QTransform.fromScale(self.viewport().width()/rect.width(),self.viewport().height()/rect.height()))
        for name,y in [('toolbar',10),('actions',58)]:
            widget=getattr(self.editor,name,None)
            if widget:
                widget.adjustSize();widget.move(10,y);widget.raise_()
        status=getattr(self.editor,'status',None)
        if status:
            status.resize(max(1,self.viewport().width()-20),30)
            status.move(10,max(0,self.viewport().height()-40));status.raise_()

    def mousePressEvent(self, event):
        e = self.editor
        if event.button() != Qt.LeftButton or e.tool == 'move':
            return super().mousePressEvent(event)
        self.start = self.mapToScene(event.position().toPoint())
        if not e.scene.sceneRect().contains(self.start): return
        e.scene.clearSelection()
        if e.tool == 'text':
            text, ok = QInputDialog.getMultiLineText(e, 'Text', 'Text:')
            if ok and text:
                e.add_layer({'kind':'text','x':self.start.x(),'y':self.start.y(),
                             'w':max(80, max(map(len,text.splitlines()))*17),'h':max(40,len(text.splitlines())*40),
                             'text':text,'color':e.color,'font_size':24})
            return
        self.points = [self.start]
        self.draft = e.scene.addPath(QPainterPath(self.start), QPen(QColor('#70bfff') if e.tool in ('region','pixels','pixelate') else QColor(e.color), e.stroke, Qt.DashLine if e.tool in ('region','pixels','pixelate') else Qt.SolidLine, Qt.RoundCap, Qt.RoundJoin))
        self.draft.setZValue(100000)

    def mouseMoveEvent(self, event):
        if self.draft is None: return super().mouseMoveEvent(event)
        point = self.mapToScene(event.position().toPoint())
        self.points.append(point)
        path = QPainterPath()
        rect = QRectF(self.start, point).normalized()
        if self.editor.tool == 'ellipse': path.addEllipse(rect)
        elif self.editor.tool in ('arrow','line','pen'):
            path.moveTo(self.start)
            for p in (self.points if self.editor.tool == 'pen' else [point]): path.lineTo(p)
            if self.editor.tool == 'arrow':
                angle = math.atan2(point.y()-self.start.y(), point.x()-self.start.x())
                for delta in (-0.5,0.5):
                    path.moveTo(point)
                    path.lineTo(point-QPointF(math.cos(angle+delta)*(12+self.editor.stroke),math.sin(angle+delta)*(12+self.editor.stroke)))
        else: path.addRect(rect)
        self.draft.setPath(path)

    def mouseReleaseEvent(self, event):
        if self.draft is None: return super().mouseReleaseEvent(event)
        e = self.editor
        point = self.mapToScene(event.position().toPoint())
        points=self.points+[point] if e.tool=='pen' else [self.start,point]
        left=min(p.x() for p in points);top=min(p.y() for p in points)
        rect=QRectF(left,top,max(1,max(p.x() for p in points)-left),max(1,max(p.y() for p in points)-top)).intersected(e.scene.sceneRect())
        e.scene.removeItem(self.draft)
        self.draft = None
        if e.tool in ('arrow','line','pen'):
            if (point-self.start).manhattanLength() < 2 and len(self.points)<3:return
        elif rect.width() < 2 or rect.height() < 2:return
        if e.tool in ('region', 'pixels'):
            if e.tool == 'region': e.set_region(rect)
            else: e.set_pixels(rect)
            e.checkpoint()
        elif e.tool == 'pixelate':
            pix = e.render(rect)
            pix = pix.scaled(max(1,int(rect.width()/14)),max(1,int(rect.height()/14)),Qt.IgnoreAspectRatio,Qt.FastTransformation)
            pix = pix.scaled(int(rect.width()),int(rect.height()),Qt.IgnoreAspectRatio,Qt.FastTransformation)
            e.add_layer({'kind':'image','x':rect.x(),'y':rect.y(),'w':rect.width(),'h':rect.height(),'pixmap':pix})
        else:
            data = dict(kind=e.tool,x=rect.x(),y=rect.y(),w=rect.width(),h=rect.height(),color=e.color,stroke=e.stroke)
            if e.tool in ('arrow','line','pen'):
                points = self.points+[point] if e.tool == 'pen' else [self.start,point]
                data['points']=[(p.x()-rect.x(),p.y()-rect.y()) for p in points]
            e.add_layer(data)


class Editor(QMainWindow):
    def __init__(self, image, output=None, monitor=None):
        super().__init__()
        self.setWindowTitle('SnapX Capture Overlay')
        self.setObjectName('snapx-overlay')
        self.output = output
        self.tool = 'region'
        self.color = '#ff4040'
        self.stroke = 3
        self.scene = QGraphicsScene(self)
        self.background = self.scene.addPixmap(image)
        self.background.setZValue(-1000)
        self.scene.setSceneRect(QRectF(image.rect()))
        self.layers = []
        self.region = None
        self.pixel_region = None
        self.region_item = self.scene.addRect(QRectF(),QPen(QColor('#70bfff'),2,Qt.DashLine))
        self.region_item.setZValue(100000)
        self.region_item.hide()
        self.pixel_item = self.scene.addRect(QRectF(), QPen(QColor('#ffcc55'),2,Qt.DashLine))
        self.pixel_item.setZValue(100001)
        self.pixel_item.hide()
        self.canvas = Canvas(self)
        self.setCentralWidget(self.canvas)
        self.toolbar = QToolBar('Capture tools')
        self.toolbar.setMovable(False)
        self.toolbar.setParent(self.canvas.viewport())
        self.buttons = {}
        for key, label in [('region','Capture area'),('pixels','Copy pixels'),('move','Move/resize'),('arrow','Arrow'),('rect','Rectangle'),
                           ('ellipse','Ellipse'),('line','Line'),('pen','Draw'),('text','Text'),('pixelate','Pixelate')]:
            button = QPushButton(label)
            button.setCheckable(True)
            button.clicked.connect(lambda checked=False,k=key:self.set_tool(k))
            self.toolbar.addWidget(button)
            self.buttons[key]=button
        self.actions = QToolBar('Image actions');self.actions.setMovable(False);self.actions.setParent(self.canvas.viewport())
        for label, fn in [('Whole screen',self.whole_screen),('Insert image',self.insert_image),('Insert QR',self.insert_qr),('Duplicate region',self.duplicate_region),
                           ('Color',self.choose_color),('Undo',self.undo),('Redo',self.redo),
                           ('Copy & save',self.finish),('Cancel',self.close)]:
            button=QPushButton(label);button.clicked.connect(fn);self.actions.addWidget(button)
        size=QSpinBox();size.setRange(1,30);size.setValue(3);size.setToolTip('Line thickness')
        size.valueChanged.connect(lambda value:setattr(self,'stroke',value));self.actions.addWidget(size)
        self.status=QStatusBar(self.canvas.viewport())
        self.status.showMessage('Capture area selects output. Copy pixels selects a source area. Ctrl+C copies it; Ctrl+V inserts an image. Move/resize: drag objects or their blue corner. Enter saves; Esc cancels.')
        self.setStyleSheet('QToolBar,QStatusBar{background:#20242b;color:white} QPushButton{padding:6px;color:white;background:#333a46;border:0;border-radius:4px;margin:2px} QPushButton:checked{background:#276cb7} QSpinBox{color:white;background:#333a46}')
        self.shortcuts=[]
        for key,fn in [('Ctrl+C',self.copy_region),('Ctrl+V',self.paste),('Ctrl+Z',self.undo),('Ctrl+Shift+Z',self.redo),
                       ('Ctrl+Y',self.redo),('Delete',self.delete_selected),('Return',self.finish),('Escape',self.close)]:
            shortcut=QShortcut(QKeySequence(key),self);shortcut.activated.connect(fn);self.shortcuts.append(shortcut)
        self.states=[];self.state_index=-1
        self.set_tool('region');self.checkpoint()
        self.resize(min(image.width(),1500),min(image.height(),1000))
        if monitor:
            self.winId()
            for screen in QApplication.screens():
                if screen.name()==monitor:
                    self.windowHandle().setScreen(screen)
                    break

    def set_tool(self, tool):
        self.tool=tool
        for key,button in self.buttons.items():button.setChecked(key==tool)
        self.canvas.setDragMode(QGraphicsView.NoDrag)
        for layer in self.layers:layer.setAcceptedMouseButtons(Qt.LeftButton if tool=='move' else Qt.NoButton)
        self.canvas.viewport().setCursor(Qt.ArrowCursor if tool=='move' else Qt.CrossCursor)

    def whole_screen(self):
        self.set_region(None);self.checkpoint()

    def set_region(self, rect):
        self.region=QRectF(rect) if rect else None
        self.region_item.setRect(rect or QRectF())
        self.region_item.setVisible(bool(rect))

    def set_pixels(self,rect):
        self.pixel_region=QRectF(rect) if rect else None
        self.pixel_item.setRect(rect or QRectF())
        self.pixel_item.setVisible(bool(rect))

    def add_layer(self,data, checkpoint=True):
        layer=Layer(data,self.checkpoint)
        layer.setZValue(len(self.layers)+1)
        self.scene.addItem(layer);self.layers.append(layer)
        self.set_tool('move');self.scene.clearSelection();layer.setSelected(True)
        if checkpoint:self.checkpoint()
        return layer

    def snapshot(self):
        layers=[]
        for layer in self.layers:
            data=dict(layer.data,x=layer.pos().x(),y=layer.pos().y(),scale=layer.scale())
            layers.append(data)
        return layers,QRectF(self.region) if self.region else None,QRectF(self.pixel_region) if self.pixel_region else None

    def checkpoint(self):
        self.states=self.states[:self.state_index+1]
        self.states.append(self.snapshot())
        # Bound memory used by pixel layers and undo history.
        self.states=self.states[-60:];self.state_index=len(self.states)-1

    def restore_state(self):
        for layer in self.layers:self.scene.removeItem(layer)
        self.layers=[]
        layers,region,pixels=self.states[self.state_index]
        for data in layers:self.add_layer(dict(data),False)
        self.set_region(region);self.set_pixels(pixels);self.scene.clearSelection()

    def undo(self):
        if self.state_index>0:self.state_index-=1;self.restore_state()

    def redo(self):
        if self.state_index+1<len(self.states):self.state_index+=1;self.restore_state()

    def render(self, rect=None):
        rect=rect or self.region or self.scene.sceneRect()
        rect=rect.intersected(self.scene.sceneRect()).toAlignedRect()
        image=QImage(rect.size(),QImage.Format_ARGB32)
        image.fill(Qt.transparent)
        selected=self.scene.selectedItems()
        self.scene.clearSelection();visible=self.region_item.isVisible();pixels_visible=self.pixel_item.isVisible();self.region_item.hide();self.pixel_item.hide()
        painter=QPainter(image)
        self.scene.render(painter,QRectF(image.rect()),QRectF(rect),Qt.IgnoreAspectRatio)
        painter.end()
        self.region_item.setVisible(visible);self.pixel_item.setVisible(pixels_visible)
        for layer in selected:layer.setSelected(True)
        return QPixmap.fromImage(image)

    def copy_region(self):
        QApplication.clipboard().setPixmap(self.render(self.pixel_region))
        self.status.showMessage('Selected pixels copied. Ctrl+V inserts a movable/resizable duplicate.')

    def paste(self):
        pix=QApplication.clipboard().pixmap()
        if pix.isNull():return
        self.insert_pixmap(pix)

    def insert_pixmap(self,pix):
        area=self.region or self.scene.sceneRect()
        scale=min(1,area.width()/max(1,pix.width()),area.height()/max(1,pix.height()))
        return self.add_layer(dict(kind='image',pixmap=pix,w=pix.width(),h=pix.height(),
            x=area.x()+20,y=area.y()+20,scale=scale))

    def duplicate_region(self):
        self.insert_pixmap(self.render(self.pixel_region))

    def insert_qr(self):
        text,ok=QInputDialog.getText(self,'Insert QR code','Text or URL:')
        if ok and text:
            import qrcode,io
            output=io.BytesIO();qrcode.make(text).save(output,format='PNG')
            pix=QPixmap();pix.loadFromData(output.getvalue());self.insert_pixmap(pix)

    def insert_image(self):
        path,_=QFileDialog.getOpenFileName(self,'Insert image',str(Path.home()/'Pictures'),'Images (*.png *.jpg *.jpeg *.webp *.bmp *.gif)')
        if path:
            pix=QPixmap(path)
            if not pix.isNull():self.insert_pixmap(pix)

    def delete_selected(self):
        selected=[layer for layer in self.layers if layer.isSelected()]
        for layer in selected:self.scene.removeItem(layer);self.layers.remove(layer)
        if selected:self.checkpoint()

    def choose_color(self):
        color=QColorDialog.getColor(QColor(self.color),self,'Annotation color')
        if color.isValid():self.color=color.name()

    def finish(self):
        pix=self.render()
        if self.output:
            Path(self.output).parent.mkdir(parents=True,exist_ok=True)
            if not pix.save(self.output,'PNG'):
                QMessageBox.critical(self,'Save failed','Unable to save the screenshot');return
        QApplication.clipboard().setPixmap(pix)
        self.close()

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--input',required=True);parser.add_argument('--output',required=True);parser.add_argument('--monitor')
    args=parser.parse_args()
    app=QApplication(sys.argv);app.setDesktopFileName('snapx-overlay')
    pix=QPixmap(args.input)
    if pix.isNull():raise SystemExit('Could not load captured screenshot')
    editor=Editor(pix,args.output,args.monitor)
    editor.showFullScreen()
    QTimer.singleShot(0, editor.canvas.sync_view)
    # Resize events also update the mapping after Wayland fullscreen configure.
    sys.exit(app.exec())

if __name__=='__main__':main()
