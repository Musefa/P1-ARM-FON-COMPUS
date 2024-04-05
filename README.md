# P1-ARM-FON-COMPUS
Pràctica 1 - ARM - Fonaments de Computadors
APUNTES:
FASE 1:
    1.- HAY QUE ADJUNTAR EL CÁLCULO DE LAS CONSTANTES DE LA FASE 1 EN COMA FIJA EN EL DOCUMENTO Y EN LOS VÍDEOS.
    2.- PREGUNTAR AL PROFE LONGITUD DE COMENTARIOS ADECUADA - PERFECTA.
FASE 2:
    1.- OPTIMIZAR INCLUDES???????? - JA OPTIMITZAT, NO TOCAR RES.
    2.- DEPENDENCIAS DEL build/geotemp.o CORRECTAS O HACER -I./include (avgmaxmintemp.i???).
    3.- HAY QUE HACER UN .o DEL avgmaxmintemp.c O CON EL DEL avmaxmintemp.s BASTA???
    4.- DOCUMENTAR 12 EN COMA FIJA Q13 !!!!!!!
    5.- EN FER START DE NOU, CANVIEN LES DADES DE LA TAULA?????????? - LOAD PREVI NECESSARI, DOCUMENTAR..
    6.- INCLUDE DEL Q13.i??? (mascara de signo necesaria)?????
    7.- ADJUNTAR CÁLCULO DIVISIÓN Q13/ENTERO.
    TO DO: Més proves.
    EXTRA: AUNQUE SEA INUTIL PONER -Lp_lib
    OPTIMIZAR AVANCE FILAS AVGMAXMIN_CITY - HECHO Y JUSTIFICAR !!!!! (mla POR add).
FASE 3:
    1.- JUSTIFICACIÓN COMENTARIOS PRODUCTO (mismo dilema que en FASE 1/2).
    2.- ADICION DE MASK_NUM VALIDA EN Q13.i???
    3.- JUSTIFICAR MAKE_Q13(1.0) /// CALCULAR MAKE_Q13(1.0) << 13. Poner directamente el número calculado o calcular << 13 dentro del código??? PONER CONSTANTE.
    4.- LIB FONCOMPUS + STARTUP.o en TESTS???
    5.- DONDE GUARDAMOS LIBQ13.a, EN DIRECTORIO BASE???
    6.- libQ13.a antes de libfoncompus.a - explicacion????
    7.- Se puede modificar el Makefile base de la fase 3 o solo añadir cosas???
    TO DO: Más pruebas (-0.0?????, USAR MASCARA DE BITS?????)
           Acabar de traduir fases 1 y 2 con nueva librería, hacer Makefile, revisar demo.o

IMPORTANTISIMOOOOO:
        -   JUSTIFICAR smull r1, r2, r0, r3 frente a smull r0, r1, r3, r0  POR EFICIENCIA TEMPORAL/DE EJECUCIÓN PARA FASE 1 (EN FASE 3 PLANTEAR COMPARACIÓN).
        -   Cambiar idioma de cociente y residuo de los comentarios de la fase 2 y 3 (al acceder a la pila para ocupar registros).
        -   Revisar errors típics (avance por matrices???).
        -   Preguntar por implementación de cambio de signo de la división en la segunda fase (en la tercera no hay otra opción).
        -   Uso de máscaras???
        -   PRUEBA DE -0.0 EN FASE 3 !!!!!!!
        -   TST CON MASCARAS!!!!!!
        -   OPTIMIZAR PROCESO CAMBIO DE SIGNO FASE 2 (y div_mod fase 3).

# ESTADO ACTUAL: Subrutinas de la fase 3 acabadas. Realizar pruebas, ensamblar librería de operaciones y adaptar fases 1 y 2 a código.

COMENTAR EN REUNIONES:
