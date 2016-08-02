FROM centos:6

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

MAINTAINER maekawa<yana.sd.iml@gmail.com>
RUN echo "install ruby environment"
RUN yum install -y git vim sudo tar wget 

RUN yum install -y epel-release
RUN yum install -y gcc-c++ git glibc-headers libffi-devel libxml3 libxml2-devel libxslt libxslt-devel libyaml-devel make nodejs npm openssl-devel readline readline-devel sqlite-devel zlib zlib-devel

## Ruby
RUN cd /usr/local/src && \
  wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz && \
  tar zxvf ruby-2.2.2.tar.gz && \
  cd ruby-2.2.2 && \
  ./configure --disable-install-doc && \
  make && \
  make install
RUN echo 'gem: --no-document' > /usr/local/etc/gemrc
RUN yum install -y patch
RUN gem update --system


RUN yum -y install mysql-server mysql-devel
RUN git clone https://coffeemk2:kazu1127@github.com/coffeemk2/twicro.git
#RUN git clone -b feature_silbus https://okamuroshogo:Okasho1010@github.com/planningdev/kyutechapp.git
WORKDIR /twicro/Twicro

RUN gem install bundler
RUN gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2/
RUN bundle config build.nokogiri --use-system-libraries

RUN wget http://mecab.googlecode.com/files/mecab-0.996.tar.gz
RUN tar zxfv mecab-0.996.tar.gz && \
    cd mecab-0.996 && \
    ./configure && \ 
    make && \
    make check && \
    make install && \
    cd 

RUN wget http://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
RUN tar zvxf mecab-ipadic-2.7.0-20070801.tar.gz && \
 cd mecab-ipadic-2.7.0-20070801 && \
 ./configure --with-charset=utf8 && \
 make && \
 make install && \
 cd

RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
RUN yum install -y mecab mecab-devel mecab-ipadic git make curl xz

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
RUN cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y

RUN bundle install --path vendor/bundle
RUN bundle config --global path 'vendor/bundle'


ENV RAILS_ENV production
