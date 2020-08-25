FROM r-base:latest

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libgit2-dev \
  libssl-dev \
  libssh-dev \
  libcurl4-openssl-dev \
  default-jdk \
  libcairo2-dev \
  libsqlite-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  libpoppler-cpp-dev \
  libmagick++-dev \
  r-cran-tidyverse \
  r-cran-devtools \
  r-cran-dplyr \
  r-cran-magick \
  r-cran-rsvg \
  && apt-get clean
RUN install2.r --error \
    --deps TRUE \
    rJava \
    SqlRender \
    DatabaseConnector \
    hexSticker \
    pkgdown \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN installGithub.r --deps TRUE \
    YuLab-SMU/ggtree \
    meerapatelmd/centipede \
    meerapatelmd/secretary \
    meerapatelmd/cave \
    meerapatelmd/rubix \
    meerapatelmd/pg13 \
&& rm -rf /tmp/downloaded_packages/

RUN mkdir -p /onco/R && mkdir -p /onco/inst/sql && mkdir -p /onco/data
COPY Run.R DESCRIPTION /onco/
COPY R/* /onco/R/
COPY inst/* /onco/inst/sql/
COPY data/* /onco/data/
WORKDIR /onco
CMD ["Rscript", "Run.R"]
