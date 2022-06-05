up:
	cd mysql && docker-compose up -d && cd .. && \
	cd redis && docker-compose up -d && cd .. && \
	cd rocketmq && docker-compose up -d && cd .. && \
	cd elasticsearch && docker-compose up -d && cd ..


down:
	cd mysql && docker-compose down && rm -rf store && cd .. && \
	cd redis && docker-compose down && cd .. && \
	cd rocketmq && docker-compose down && rm -rf store && cd .. && \
	cd elasticsearch && docker-compose down && cd ..

