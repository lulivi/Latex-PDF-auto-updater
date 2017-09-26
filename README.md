# Latex PDF auto updater

## Requirements

- latexmk
- inotify-tools

## Installation

You can clone this repository with the command below
```
git clone git@github.com:lulivi/Latex-PDF-auto-updater.git
```
or just click on the "Download as zip" button.

## Usage

Firstly you have to add the following variable to your home directory to set up the latexmk previewer with your favourite pdf viewer (e.g. evince):
```bash
echo '$pdf_previewer = "start evince";' >> $HOME/.latexmkrc
```
Then, you can create an alias for the script, for example:
```bash
alias updatePdfLatex="/PATH/TO/SCRIPT/updatePdfLatex.sh"
```
You have to execute this script from the directory in which you have your Latex files. Simply run:
```bash
/PATH/TO/SCRIPT/updatePdfLatex.sh <metafiles_directory>
```
After this, you can edit your tex files in the directory and let the script update the pdf for you.

## References

I got the idea of this script mainly from two blog entries made by [Elbaulp](https://github.com/Elbaulp):

- [Compilar automáticamente ficheros en latex mientras los modificamos](https://elbauldelprogramador.com/compilar-automaticamente-ficheros-en-latex-mientras-los-modificamos/).
- [Ejecutar un script al modificar un fichero con inotify](https://elbauldelprogramador.com/ejecutar-un-script-al-modificar-un-fichero-con-inotify).

Also you can checkout the [latexmk man page](https://www.mankier.com/1/latexmk).

## Contact

You can contact me in luislivilla at gmail.com or directly with [Telegram](http://t.me/lulivi).

## License

Checkout [LICENSE](https://github.com/lulivi/Latex-PDF-auto-updater/blob/master/LICENSE)
