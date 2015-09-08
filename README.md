# earthwall

earthwall.sh is a simple bash script to change your OSX wallpaper to a random image from [earthview.withgoogle.com](https://earthview.withgoogle.com/).
The script was tested on Yosemite and Lion.
You can set up a periodic wallpaper change using cron. Take a look at the example in [Cron](https://github.com/ngserro/earthwall#cron).

## Installation

The script only supports OSX and requires an internet connection to download the wallpaper.
Install the script using any of the methods bellow: 

### Install using Git

The repository can be cloned to any location.

```bash
git clone https://github.com/ngserro/earthwall.git; cd earthwall; chmod +x earthwall.sh
```

### Git-free installation

To install without Git:

```bash
cd; curl -L https://github.com/ngserro/earthwall/tarball/master | tar -xzv; cd ngserro-earthwall-*; chmod +x earthwall.sh
```

If you want to update you can simply run that command again.

## Usage

Make sure you are in the directory where the script is located and run:

```bash
./earthwall.sh 
```
That's it! Your wallpaper is now an image from earthview.withgoogle.com.

## Cron

If you want your wallpaper to change periodically you can set up the script execution in crontab:

```bash
crontab -e
```

Then add a line like this:

```bash
0 */2 * * * PATH_TO_SCRIPT/earthwall.sh
```
This is an example for changing the wallpaper every 2 hours. Change PATH_TO_SCRIPT accordingly.
