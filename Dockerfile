FROM jekyll/jekyll:latest

MAINTAINER Fabien Roy

ARG build_command
ENV BUILD_COMMAND ${build_command}

CMD ${BUILD_COMMAND}