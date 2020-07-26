import requests

VERSIONS_URL = 'https://launchermeta.mojang.com/mc/game/version_manifest.json'


def get_latest_server_version():
    r = requests.get(VERSIONS_URL)
    if r.status_code <= 399:
        versions = r.json()
        latest = list(filter(lambda version: version['type'] == 'release', versions['versions']))[0]
        return latest['id']
    else:
        exit(1)


def main():
    import sys
    sys.stdout.write(get_latest_server_version())


if __name__ == "__main__":
    main()