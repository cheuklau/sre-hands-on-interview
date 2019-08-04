import datetime
import subprocess
import sys
import time

def initialize():
    '''
    This just sets up the required indices in Elasticsearch so the Kibana dashboards work.

    '''


    f = open('/var/log/service.log', 'w+')
    f.write('[%s] INFO: Starting business-critical process!\n' % (datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
    f.close()

    sys.exit(0)


if __name__ == '__main__':
    initialize()
