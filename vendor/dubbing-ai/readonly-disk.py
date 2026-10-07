#!/usr/bin/env python3
"""Read-only NBD view exposing copied boot sectors and only the Windows partition."""
import errno, hashlib, json, os, pathlib, pwd, socket, struct, subprocess, threading
VM=pathlib.Path('@HOME@/.local/share/dubbing-ai/vm')
SOURCE='/dev/nvme0n1p3'
START=239616*512
LENGTH=2281908224*512
SIZE=START+LENGTH+33*512
SOCKET='/run/user/1000/dubbing-ai/backing.sock'
# Fail closed: an overlay is valid only while its source cannot change.
opts=subprocess.check_output(['findmnt','-no','OPTIONS','/mnt/windows-c'],text=True).strip().split(',')
if 'ro' not in opts: raise SystemExit('Windows source must be mounted read-only before starting the VM')
fd=os.open(SOURCE,os.O_RDONLY)
account=pwd.getpwnam('user');os.initgroups(account.pw_name,account.pw_gid);os.setgid(account.pw_gid);os.setuid(account.pw_uid)
header=(VM/'windows-header.raw').read_bytes()[:START]
tail=(VM/'windows-gpt-tail.raw').read_bytes()
# NTFS metadata fingerprint detects source changes between VM sessions.
boot=os.pread(fd,512,0)
bps=struct.unpack_from('<H',boot,11)[0]; cluster=bps*boot[13]
mft_lcn=struct.unpack_from('<Q',boot,48)[0]
rsize_raw=struct.unpack_from('<b',boot,64)[0]
rsize=(1<<-rsize_raw) if rsize_raw<0 else rsize_raw*cluster
record=bytearray(os.pread(fd,rsize,mft_lcn*cluster))
usa_off,usa_count=struct.unpack_from('<HH',record,4)
for sector in range(1,usa_count):
 record[sector*bps-2:sector*bps]=record[usa_off+sector*2:usa_off+sector*2+2]
attr=struct.unpack_from('<H',record,20)[0]; runs=[]; mft_size=0
while attr+16<=len(record):
 kind,alen=struct.unpack_from('<II',record,attr)
 if kind==0xffffffff or alen==0: break
 if kind==0x80 and record[attr+8] and record[attr+9]==0:
  roff=struct.unpack_from('<H',record,attr+32)[0]; mft_size=struct.unpack_from('<Q',record,attr+48)[0]
  pos=attr+roff; lcn=0
  while pos<len(record) and record[pos]:
   n=record[pos];pos+=1; nl=n&15;no=n>>4
   count=int.from_bytes(record[pos:pos+nl],'little');pos+=nl
   if no:
    lcn+=int.from_bytes(record[pos:pos+no],'little',signed=True);pos+=no
    runs.append((lcn*cluster,count*cluster))
   else: raise SystemExit('Unexpected sparse MFT run')
  break
 attr+=alen
if not runs or not mft_size: raise SystemExit('Unable to fingerprint Windows NTFS metadata')
h=hashlib.sha256(boot); remaining=mft_size
for off,length in runs:
 length=min(length,remaining);remaining-=length
 for pos in range(0,length,4*1024*1024):
  chunk_size=min(4*1024*1024,length-pos)
  chunk_data=os.pread(fd,chunk_size,off+pos)
  if len(chunk_data)!=chunk_size:raise SystemExit('Short NTFS metadata read')
  h.update(chunk_data)
 if remaining<=0: break
if remaining:raise SystemExit('NTFS fingerprint is incomplete')
fingerprint=h.hexdigest()
header_fingerprint=hashlib.sha256(header+tail).hexdigest()
(VM/'source-current.json').write_text(json.dumps({'fingerprint':fingerprint,'mft_bytes':mft_size,'disk_size':SIZE,'boot_fingerprint':header_fingerprint}))
# Source was opened read-only; relinquish root before serving the socket.
pathlib.Path(SOCKET).unlink(missing_ok=True)
server=socket.socket(socket.AF_UNIX);server.bind(SOCKET);os.chmod(SOCKET,0o600);server.listen(8)
def read_disk(off,length):
 result=bytearray(length); end=off+length
 a=max(off,0); b=min(end,START)
 if a<b:result[a-off:b-off]=header[a:b]
 a=max(off,START);b=min(end,START+LENGTH)
 if a<b:
  data=os.pread(fd,b-a,a-START)
  if len(data)!=b-a:raise OSError(errno.EIO,'Short source read')
  result[a-off:b-off]=data
 a=max(off,START+LENGTH);b=min(end,SIZE)
 if a<b:result[a-off:b-off]=tail[a-(START+LENGTH):b-(START+LENGTH)]
 return result
def receive(c,n):
 chunks=[]
 while n:
  part=c.recv(n)
  if not part:raise EOFError
  chunks.append(part);n-=len(part)
 return b''.join(chunks)
def serve(c):
 try:
  # Standard oldstyle negotiation; readonly export, no writable commands advertised.
  c.sendall(b'NBDMAGIC'+struct.pack('>QQI',0x0000420281861253,SIZE,3)+bytes(124))
  while True:
   magic,flags,cmd,handle,off,length=struct.unpack('>IHH8sQI',receive(c,28))
   if magic!=0x25609513:break
   if cmd==2:break
   if cmd==1:
    receive(c,length);c.sendall(struct.pack('>II8s',0x67446698,errno.EROFS,handle));continue
   if cmd!=0 or length>32*1024*1024 or off+length>SIZE:
    c.sendall(struct.pack('>II8s',0x67446698,errno.EINVAL,handle));continue
   try:data=read_disk(off,length)
   except OSError:
    c.sendall(struct.pack('>II8s',0x67446698,errno.EIO,handle));continue
   c.sendall(struct.pack('>II8s',0x67446698,0,handle)+data)
 except (EOFError,ConnectionError,OSError):pass
 finally:c.close()
while True:
 connection,_=server.accept();threading.Thread(target=serve,args=(connection,),daemon=True).start()
