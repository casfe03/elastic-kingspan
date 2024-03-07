# Versão do Logstash
FROM docker.elastic.co/logstash/logstash:8.12.2

# Copie seu arquivo de configuração personalizado do Logstash para o container
# O arquivo 'logstash.conf' deve estar no mesmo diretório que este Dockerfile
COPY logstash.conf /usr/share/logstash/config/logstash.conf

# Opcional: Adicione certificados SSL ou outros arquivos necessários
# COPY path/to/your/cert.crt /path/in/container/cert.crt
# COPY path/to/your/cert.key /path/in/container/cert.key

# O Logstash por padrão irá buscar as configurações em /usr/share/logstash/pipeline/
# Portanto, é preciso configurar o caminho se um local diferente for utilizado
ENV PATH_CONFIG /usr/share/logstash/config/logstash.conf
RUN CHMOD 777 /usr/share/logstash/config/logstash.yml

# Exponha a porta que o Logstash usará
EXPOSE 5044

# O ponto de entrada padrão do Logstash é o comando 'logstash'
# Os argumentos padrão são -f para o arquivo de configuração e --config.reload.automatic
CMD ["logstash", "-f", "${PATH_CONFIG}", "--config.reload.automatic"]
