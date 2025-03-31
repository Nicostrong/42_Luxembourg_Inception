# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nfordoxc <nfordoxc@42.luxembourg.lu>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 13:14:58 by nfordoxc          #+#    #+#              #
#    Updated: 2025/03/31 13:30:20 by nfordoxc         ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

FROM debian:latest
MAINTENER nfordoxc <nfordoxc@student.42.luxembourg.lu>
RUN apt update
apt upgrade
apt install nginx
