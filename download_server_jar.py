import requests as r
import re
import sys

def get_server_download_urls():
    url = 'https://mcversions.net/'
    response = r.get(url)

    if not response or response.status_code >= 400:
        return None

    page = str(response.content).replace('>', '>\n')
    hits = re.findall(r'"https://.*/server.jar".*download="minecraft_server-.*.jar"', str(page))

    servers = list()

    for hit in hits:
        server_find = re.findall(r'"(.+?)"', hit)
        servers.append({ 'version': server_find[2].replace('minecraft_server-','').replace('.jar', ''), 'url': server_find[0] })
    return servers

def download_server_jar(path, url):
    file = path + '/server.jar'
    with open(file, 'wb') as server_file:
        response = r.get(url)
        if response and response.status_code <= 399:
            server_file.write(response.content)


def main():
    path = sys.argv[2]
    version = sys.argv[1]

    servers = get_server_download_urls()

    if version.lower() != 'latest':
        url = list(filter(lambda server: server['version'] == version, servers))[0]['url']
    else:
        url = servers[0]['url']

    download_server_jar(path, url)


if __name__ == '__main__':
    main()
