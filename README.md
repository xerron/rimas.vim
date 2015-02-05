# rimas.vim

Diccionario de rimas para Vim.
Esta es una herramienta muy util para los poetas mallditos como yo.

## Dependencias

https://github.com/xerron/merimas

## Configuración

Establecer el path a merimas.jar

    let g:rimas_merimas_path = /path/to/merimas/

## Uso

Mostrar rimas consonantes para una palabra:

    :Rima <palabra>

Mostrar rimas consonantes con n silabas:

    :Rima [numero] <palabra>

Mostrar rimas consonantes que comienzan con vocal(c) o consonante(c)

    :Rima [v|c] <palabra>

Un ejemplo mas completo:

    :Rima [v|c] [numero] <palabra>

Mostrar rimas asonantes:

    :RimaAsonante [v|c] [numero] <palabra>

## Licencia

MIT.

## Creditos

XERRON©, si te es util ponle una estrella.




