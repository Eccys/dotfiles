#!/usr/bin/env python3
import importlib.util,pathlib,os
os.environ['QT_QPA_PLATFORM']='offscreen'
from PySide6.QtWidgets import QApplication
from PySide6.QtGui import QPixmap,QColor
from PySide6.QtCore import QRectF,Qt
from PySide6.QtTest import QTest
p=pathlib.Path(__file__).resolve().parents[1]/'home/.local/share/snapx-workflow/overlay.py'
s=importlib.util.spec_from_file_location('overlay',p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
a=QApplication([]);bg=QPixmap(200,200);bg.fill(QColor('blue'));e=m.Editor(bg);e.resize(800,500);e.show();a.processEvents()
x=QPixmap(40,30);x.fill(QColor('red'));e.add_layer(dict(kind='image',pixmap=x,w=40,h=30,x=10,y=10));e.set_pixels(QRectF(10,10,40,30));e.set_region(QRectF(0,0,150,150));e.copy_region();e.paste();l=e.layers[-1];l.setPos(80,80);l.setScale(.5);e.checkpoint()
im=e.render().toImage();assert im.width()==150 and im.pixelColor(85,85).name()=='#ff0000';assert im.pixelColor(120,120).name()=='#0000ff';e.undo();e.redo();assert e.layers[-1].scale()==.5
for tool in ('arrow','line'):
 e.set_tool(tool);v=e.canvas.viewport();start=e.canvas.mapFromScene(30,120);end=e.canvas.mapFromScene(120,120);QTest.mousePress(v,Qt.LeftButton,pos=start);QTest.mouseMove(v,end);assert e.canvas.draft is not None;QTest.mouseRelease(v,Qt.LeftButton,pos=end);assert e.layers[-1].data['kind']==tool
 assert e.render().toImage().pixelColor(70,120).name()!='#0000ff'
assert e.pixel_region==QRectF(10,10,40,30);e.whole_screen();e.undo();assert e.region==QRectF(0,0,150,150)
print('PASS: pixel duplication, independent capture area, insertion/move/scale, undo/redo, horizontal live arrows/lines rendered')

# Resizing/fullscreen must keep the entire image mapped to the entire viewport.
e.resize(1080,1920);a.processEvents();v=e.canvas.viewport();origin=e.canvas.mapFromScene(0,0);corner=e.canvas.mapFromScene(200,200)
assert abs(origin.x())<=1 and abs(origin.y())<=1
assert abs(corner.x()-v.width())<=1 and abs(corner.y()-v.height())<=1
assert v.size()==e.size()
assert e.toolbar.isVisible() and e.actions.isVisible() and e.status.isVisible()
print("PASS: full canvas after resize; controls visible over image without shrinking it")
