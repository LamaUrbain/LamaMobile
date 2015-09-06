FROM ubuntu:precise
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y update && apt-get -y install python-software-properties
RUN add-apt-repository --yes ppa:beineri/opt-qt541
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y update && apt-get -qq -y install build-essential qt54base qt54location qt54declarative libglu1-mesa-dev


RUN groupadd lamaurbain && useradd -m lamaurbain -g lamaurbain
EXPOSE 8000
WORKDIR /home/lamaurbain

ADD . /home/lamaurbain
RUN /bin/bash -c "source /opt/qt54/bin/qt54-env.sh && \
    	      	  qmake projects.pro && \
      		  make"
CMD /bin/bash -c "source /opt/qt54/bin/qt54-env.sh && bash test.sh"
