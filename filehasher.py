#!/usr/bin/python
import hashlib,os,sys,sqlite3
conn = sqlite3.connect('/tmp/files.db')
curs = conn.cursor()

def dbInit(curs):
    curs.execute('''create table filetable (hashsum, filepath''')
    return

def fileChecksum(filePath):
    try:
        hsh = ""
        with open(filePath, 'rb') as fh:
            m = hashlib.sha1()
            while True:
                data = fh.read(8192)
                if not data:
                    break
                m.update(data)
            hsh=m.hexdigest()
    except IOError:
        pass
    return hsh

def main(path):
    for dirpath, dirs, files in os.walk(path):
        for f in files:
            #print f
            y=os.path.abspath(dirpath)
            xfile=os.path.join(y,f)
            hashsum = fileChecksum(unicode(xfile,'UTF-8'))
            print hashsum, xfile
            curs.execute(''' insert into filetable values (?,?) ''', (hashsum,unicode(xfile,'UTF-8')))
        conn.commit()
    #for x in curs.execute(''' select * from filetable order by hashsum '''):
        #print x

if __name__ == "__main__":
    main(".")
