import requests
import re
import sys


def get_server_download_url(version):
    versions_url = 'https://launchermeta.mojang.com/mc/game/version_manifest.json'

    r = requests.get(versions_url)
    if r.status_code <= 399:
        versions = r.json()

        version_url = list(filter(lambda v: v['id'] == version, versions['versions']))[0]['url']

        s = requests.get(version_url)
        if s.status_code <= 399:
            server = s.json()['downloads']['server']
            return server['url']

    exit(1)

def download_server_jar(path, url):
    file = path + '/server.jar'
    with open(file, 'wb') as server_file:
        response = requests.get(url)
        if response and response.status_code <= 399:
            server_file.write(response.content)


def main():
    path = sys.argv[2]
    version = sys.argv[1]

    if version.lower() != 'latest':
        url = get_server_download_url(version)
    else:
        from get_latest_version import get_latest_server_version
        version = get_latest_server_version()
        url = get_server_download_url(version)

    download_server_jar(path, url)


if __name__ == '__main__':
    main()
