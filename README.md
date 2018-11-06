# Latex project example

## Dependencies

You will need `latexmk` for this script:

To install it in Debian based distributions:
```shell
sudo apt install latexmk
```

And in Archlinux:
```shell
sudo pacman -S texlive-core
```

## Installation

You can clone this repository with the command below
```shell
git clone git@github.com:lulivi/latex-project-example.git
```
or just click on the "Download as zip" button.

## Usage

1. Firstly, select your favourite pdf viewer. To define it, you should go to the script `update_pdf_latex.sh` and modify the line containing the following text:
  ```bash
  PREVIEWER="evince"
  ```
  Change `evince` with whichever pdf viewer you want.

2. Secondly, go to your desired directory where you will use the latex template and run this command:
  ```shell
  bash /path/to/repository/latex_project_copy.sh
  ```
  This will copy the required files to your current directory.

3. Finally, run the updater script. Use `./update_pdf_latex.sh -h` to show you the help.

## References

I got the idea of this script mainly from two blog entries made by [Elbaulp](https://github.com/Elbaulp):

- [Compilar automáticamente ficheros en latex mientras los modificamos](https://elbauldelprogramador.com/compilar-automaticamente-ficheros-en-latex-mientras-los-modificamos/).
- [Ejecutar un script al modificar un fichero con inotify](https://elbauldelprogramador.com/ejecutar-un-script-al-modificar-un-fichero-con-inotify).

Also you can checkout the [latexmk man page](https://www.mankier.com/1/latexmk).

## Contact

You can contact me in luislivilla at gmail.com or directly with [Telegram](http://t.me/lulivi).

## License

Checkout [LICENSE](./LICENSE)
