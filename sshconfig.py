#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sqlite3
import csv
import os


def initdb(c, conn):
    c.execute('''DROP TABLE IF EXISTS sshconfig;''')
    conn.commit()
    c.execute('''CREATE TABLE sshconfig (priority text, host text, hostname text, user text, identityfile text, port text);''')
    conn.commit()
    return


def loaddb(c, conn, configfile):
    with open(configfile, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=';', quotechar='"')
        next(reader, None)
        for row in reader:
            priority, host, hostname, user, identityfile, port = row[
                0], row[1], row[2], row[3], row[4], row[5]
            c.execute('''INSERT INTO sshconfig VALUES ('%s', '%s', '%s', '%s', '%s', '%s')''' % (
                priority, host, hostname, user, identityfile, port))
            conn.commit()
    return


def clean_csv(c, conn, configfile):
    initdb(c, conn)
    loaddb(c, conn, configfile)
    f = open(configfile, 'r')
    fline = f.readline()
    o = open(configfile+'tmp', 'w')
    o.write(fline)
    f.close()
    stmt = "select distinct priority,host,hostname,user,identityfile,port"
    stmt += "\nfrom sshconfig"
    stmt += "\norder by host,priority"
    hosts = c.execute(stmt)
    for host in hosts:
        # print(host)
        h = "\"%s\";" % host[0]
        h += "\"%s\";" % host[1]
        h += "\"%s\";" % host[2]
        h += "\"%s\";" % host[3]
        h += "\"%s\";" % host[4]
        h += "\"%s\"" % host[5]
        o.write(h+"\n")
        pass
    o.close()
    os.rename(configfile+'tmp', configfile)
    initdb(c, conn)
    loaddb(c, conn, configfile)
    return


def write_config(c, configout):
    f = open(configout, 'w')
    f.write(config_defaults())
    sql = " SELECT priority,host,hostname,user,identityfile,port "
    sql += "FROM sshconfig "
    sql += "ORDER BY host, priority"
    hosts = c.execute(sql)
    for h in hosts:
        host, hostname, user, idfile, port = h[1], h[2], h[3], h[4], h[5]
        f.write("Host %s" % (host) + "\n")
        f.write("\tHostName %s" % (hostname) + "\n")
        if user != "":
            f.write("\tUser %s" % (user) + "\n")
        if idfile != "":
            f.write("\tIdentityFile %s/.ssh/%s" %
                    (os.environ['HOME'], idfile) + "\n")
        if port != "":
            f.write("\tPort %s" % (port) + "\n")
    f.close()
    return


def config_defaults():
    defaults = "# defaults"
    defaults += "\nHost *"
    defaults += "\n\tForwardAgent no"
    defaults += "\n\tForwardX11 no"
    defaults += "\n\tForwardX11Trusted yes"
    defaults += "\n\tProtocol 2"
    defaults += "\n\tServerAliveInterval 60"
    defaults += "\n\tServerAliveCountMax 30"
    defaults += "\n\tIdentitiesOnly yes"
    defaults += "\n\tCiphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr"
    defaults += "\n\tCompression no"
    defaults += "\n"
    return defaults


def main():
    # file system
    configout = os.environ['HOME'] + '/.ssh/config'
    configfile = os.environ['HOME'] + '/workspace/ssh/sshconfig.csv'
    # configout = 'sshconfig.cfg'
    # configfile = 'sshconfig.csv'
    # Database
    conn = sqlite3.connect(':memory:')
    c = conn.cursor()
    clean_csv(c, conn, configfile)
    write_config(c, configout)
    c.close()
    return


if __name__ == "__main__":
    main()
