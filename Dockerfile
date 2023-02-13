FROM apurba/mule4docker:v2

COPY */target/*.jar /opt/mule/apps/

ENV secure_key=mule

ENV mule_env=dev

EXPOSE 8082

CMD [ "/opt/mule/bin/mule", "-M-Dsecure.key=$secure_key", "-M-Dmule.env=$mule_env"]
