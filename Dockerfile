# Versão do Logstash
FROM docker.elastic.co/logstash/logstash:8.12.2

# Copie seu arquivo de configuração personalizado do Logstash para o container
# O arquivo 'logstash.conf' deve estar no mesmo diretório que este Dockerfile
COPY logstash.conf /usr/share/logstash/config/logstash.conf

# Defina o proprietário e as permissões para o diretório de configuração
USER root
RUN chown logstash:root  /usr/share/logstash/config/logstash.conf
RUN chown logstash:root /usr/share/logstash/config/logstash.yml && \
    chmod 777 /usr/share/logstash/config/logstash.yml



# Baixar e extrair o Elastic Agent
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.12.2-linux-x86_64.tar.gz && \
    tar xzvf elastic-agent-8.12.2-linux-x86_64.tar.gz
    
# Substitua a URL e o token de inscrição pelos seus valores reais
RUN pwd
RUN ls -la
RUN /usr/share/logstash/elastic-agent-8.12.2-linux-x86_64/elastic-agent install -n --url=https://8943fceed2f04dcd82b5bbaf85a6e61b.fleet.eastus2.azure.elastic-cloud.com:443 --enrollment-token=enlSOEdZNEJ3c3dKbmd6b1VvbVg6SUtJemlJNExScjJ4MHQ4cWJaaGhYQQ==

# Troque de volta para o usuário padrão do logstash após ter alterado as permissões
USER logstash

# Opcional: Adicione certificados SSL ou outros arquivos necessários
# COPY path/to/your/cert.crt /path/in/container/cert.crt
# COPY path/to/your/cert.key /path/in/container/cert.key

# Exponha a porta que o Logstash usará
EXPOSE 5044

# O ponto de entrada padrão do Logstash é o comando 'logstash'
# Os argumentos padrão são -f para o arquivo de configuração e --config.reload.automatic
CMD ["logstash", "-f", "/usr/share/logstash/config/logstash.conf", "--config.reload.automatic"]
