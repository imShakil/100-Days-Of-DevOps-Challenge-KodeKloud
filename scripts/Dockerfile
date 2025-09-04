# day 41

FROM ubuntu:24.04 as base


RUN apt update && \
    apt install -y apache2

RUN sed -i 's/80/5002/g' /etc/apache2/ports.conf && \
    sed -i 's/80/5002/g' /etc/apache2/sites-available/000-default.conf

CMD ["apache2ctl", "-D", "FOREGROUND"]
