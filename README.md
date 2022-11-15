  * https://www.ifj.edu.pl/dept/no6/nz62/www/
  * github pages https://grzanka.github.io/nz62www/

Clone the repo:

```bash
git clone git@github.com:grzanka/nz62www.git --recursive
```

or
```bash
git clone git@github.com:grzanka/nz62www.git
git submodule update --init
```

Install Hugo:

```bash
sudo snap install hugo
```

or:

```bash
sudo apt install hugo
```

Generate the website:

```bash
cd nz62www
hugo
```

Make a mirror of existing website:

```bash
lftp sftp://USERNAME:PASSWORD@web.ifj.edu.pl:PORT -e 'mirror --verbose --use-pget-n=8 -c /nz62 /sftp/grzanka/nz62www/backup/nz62_20221115'
```

Deploy genereated website:

```bash
lftp sftp://USERNAME:PASSWORD@web.ifj.edu.pl:PORT -e 'mirror -R --verbose --use-pget-n=8 -c /sftp/grzanka/nz62www/public/ /nz62/'
```

Fix permissions:

```bash
cd nz62
chmod -R o+rx .
```