Docker Clamav
=============

**Features:**

* clamav 0.99
* Unofficial sigs
* Freshclam
* Cron
* Syslog redirect to docker

Installation
------------

* Requires Docker 1.10+ (tested with 1.10.3)

::

    # build base image
    docker build -t rs/base-image:xenial https://github.com/srault95/baseimage-docker.git#base-ubuntu-xenial:image

    # build clamav image
    docker build -t rs/clamav:xenial https://github.com/srault95/rs-clamav.git

    # set latest tag (optional)
    docker tag rs/clamav:xenial rs/clamav:latest

    # run container
    mkdir /home/clamav && cd /home/clamav
    docker run -d --name clamav -p 127.0.0.1:3310:3310 -v /var/run/clamav:/var/run/clamav -v $PWD/db:/var/lib/clamav rs/clamav

Testing
-------

::

    # Test with local python (requires python3)
    docker clone https://github.com/srault95/rs-clamav.git
    ./pyclamd.py --host 127.0.0.1 --port 3310 ping
    
    # Test with docker python
    docker clone https://github.com/srault95/rs-clamav.git
    docker run -it --rm -v $PWD:/code python:3 /code/pyclamd.py --host 127.0.0.1 --port 3310 ping 

    echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > /tmp/eicar
    ./pyclamd.py --stream --filepath /tmp/eicar scan
        {'delay': 0.0013911724090576172,
         'error': None,
         'filename': 'eicar',
         'is_error': False,
         'size': 69,
         'status': 'FOUND',
         'virus': 'Eicar-Test-Signature'}
        
        
Usage in Amavisd-new
--------------------

::

     ['ClamAV-clamd',
       \&ask_daemon, ["CONTSCAN {}\n", "/var/run/clamav/clamd.ctl"],
       qr/\bOK$/m, qr/\bFOUND$/m,
       qr/^.*?: (?!Infected Archive)(.*) FOUND$/m ],
    
    );

Usage in Radical-Spam Amavisd-new
---------------------------------

- Change socket volume to /var/rs/var/run/clamav 

::

    mkdir /home/clamav && cd /home/clamav
    docker run -d --name clamav -p 127.0.0.1:3310:3310 -v /var/rs/var/run/clamav:/var/run/clamav -v $PWD/db:/var/lib/clamav rs/clamav

     ['ClamAV-clamd',
       \&ask_daemon, ["CONTSCAN {}\n", "/var/run/clamav/clamd.ctl"],
       qr/\bOK$/m, qr/\bFOUND$/m,
       qr/^.*?: (?!Infected Archive)(.*) FOUND$/m ],
    
    );

                