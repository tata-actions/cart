#Thing's	Included in node:20?	Notes
#1.Base OS (Linux)	✅	Debian/Alpine
#2.Node.js 20 software	✅	Pre-installed
#3.npm	✅	Comes with Node
#4.Your code	❌	You add using COPY
#5.Node modules


FROM node:20.19.5-alpine3.21 AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
# this may add extra cache memory
RUN npm install 


FROM node:20.19.5-alpine3.21
# Create a group and user
WORKDIR /opt/server
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
    chown -R roboshop:roboshop /opt/server
EXPOSE 8080
LABEL com.project="roboshop" \
      component="cart" \
      created_by="sivakumar"
ENV REDIS_HOST="redis"  \
    CATALOGUE_HOST="catalogue" \
    CATALOGUE_PORT="8080" 
    # note here mongodb is contanier name docker resolve to its container IP
# copying the build installtion's from above image to here so tht image size willl reduce  
#after copying all files to /opt/server onership need to change to user inside conatiner tht we created (roboshop user)   
COPY --from=build --chown=roboshop:roboshop  /opt/server /opt/server  

USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]



#FROM node:20
 # this node image come with base os, node software and npm packages  
 #WORKDIR /opt/server
 #COPY package.json .
 #COPY server.js .
 #RUN npm install
#ENV REDIS_HOST="redis"  \
 #   CATALOGUE_HOST="catalogue" \
  #  CATALOGUE_PORT="8080"
#CMD ["node", "server.js"]   
   