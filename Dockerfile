FROM jekyll/jekyll:latest

ARG build_command
ENV BUILD_COMMAND ${build_command}

CMD ${BUILD_COMMAND}