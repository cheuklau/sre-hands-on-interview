import datetime
import subprocess
import sys
import time
import random
import getopt

def service():
    '''
    This is our business-critical service. When it runs, it will initiate the following:

    1. Sleep for 90 seconds
    2. Write WARN messages for 30 seconds about output directory near capacity
    3. Write a 1GB file to /run/usr/1000 (this will cause it to go to 100% full)
        - Note: This is actually a psuedo filesystem that will empty when session is closed!
    4. Write ERROR message with a full dummy stack-trace ending with "caused by: no space left on device"
    5. Terminate program

    Total transient time: approx. 120 seconds
    '''

    # Check the size of /run/user/1000, if full this cannot start
    command = 'du /run/user/1000 | cut -f1'
    result = int(subprocess.check_output(command, shell=True).strip())
    if result > 100000:
        sys.exit('ERROR: Cannot start. No space left on device')

    # Write INFO messages once every 5 seconds to /var/log for 120 seconds
    f = open('/var/log/service.log', 'w+')
    for i in range(1,24):
        f.write('[%s] INFO: %s documents processed\n' % (datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), str(random.randint(1,1000))))
        f.flush()
        time.sleep(5)

    # Write WARN messages once every 5 seconds to /var/log for 45 seconds
    f = open('/var/log/service.log', 'w+')
    for i in range(1,9):
        f.write('[%s] INFO: %s documents processed\n' % (datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), str(random.randint(1,1000))))
        f.write('[%s] WARN: Low space on device. %s%% remaining.\n' % (datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), str(100-i*10)))
        f.flush()
        time.sleep(5)

    # Generate a 1GB dummy file into /run/user/1000
    command = 'dd if=/dev/zero of=/run/user/1000/dummy.log bs=1M count=1024'
    try:
        result = subprocess.check_output(command, shell=True).strip()
    except:
        pass

    # Write final ERROR message then exit
    f.write('[%s] ERROR: No space left on device\n' % datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    f.flush()
    f.close()

    sys.exit(1)


if __name__ == '__main__':
    service()
