#!/bin/bash 

UBOOQUITY_PORT=2202
ADMIN_PORT=2203
# Uncomment the following line to allocate more memory to Ubooquity
# MEM_OPT=-Xmx512m

count=`pgrep -f Ubooquity.jar`

case "$1" in
        start)
			if [ -z "$count" ];
				then
				    nohup java $MEM_OPT -jar Ubooquity.jar --headless --libraryport $UBOOQUITY_PORT --adminport $ADMIN_PORT --remoteadmin </dev/null &>ubooquity.log &
					echo Ubooquity has been started;
				else
					echo Ubooquity is already running;
			fi            
            ;;
         
        stop)
			if [ -z "$count" ];
				then
				    echo Ubooquity is NOT running, no need to stop it;
				else 
					echo stopping Ubooquity...
					pkill -f "Ubooquity.jar" </dev/null &>/dev/null &
					echo Waiting 10 seconds before checking the server stopped...;
					sleep 10

					check=`pgrep -f Ubooquity.jar`
					if [ -z "$check" ];
						then
							echo Ubooquity has been stopped;
						else
							echo Failed to stop Ubooquity: you can either wait a few more seconds or kill it manually;
					fi
			fi
            ;;
         
        status)
			if [ -z "$count" ];
				then 
					echo Ubooquity is NOT running;
				else
				    echo Ubooquity is RUNNING;
			fi
            ;;
			
        *)
            echo $"Usage: $0 {start|stop|status}"
            exit 1
 
esac
