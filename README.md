# P1-ARM-FON-COMPUS
<img alt="On progress" src="https://img.shields.io/badge/status-on_progress-yellow">
<h2>Pràctica 1 - ARM - Fonaments de Computadors</h2>
APUNTES:
<p style="color:green">CORREGIDO</p>
<p style="color:purple">EN PROCESO</p>
<p style="color:yellow">PREGUNTAR</p>
<p style="color:orange">DOCUMENTAR</p>
<p style="color:red">ERRORES DETECTADOS</p>
<h3>FASE 1:</h3>
    <p style="color:orange">1.- HAY QUE ADJUNTAR EL CÁLCULO DE LAS CONSTANTES DE LA FASE 1 EN COMA FIJA EN EL DOCUMENTO Y EN LOS VÍDEOS.</p>
    <p style="color:green">2.- PREGUNTAR AL PROFE LONGITUD DE COMENTARIOS ADECUADA - PERFECTA.</p>
<h3>FASE 2:</h3>
    <p style="color:green">1.- OPTIMIZAR INCLUDES???????? - JA OPTIMITZAT, NO TOCAR RES.</p>
    <p style="color:yellow">2.- DEPENDENCIAS DEL build/geotemp.o CORRECTAS O HACER -I./include (avgmaxmintemp.i???).</p>
    <p style="color:yellow">3.- HAY QUE HACER UN .o DEL avgmaxmintemp.c O CON EL DEL avmaxmintemp.s BASTA???</p>
    <p style="color:orange">4.- DOCUMENTAR 12 EN COMA FIJA Q13 !!!!!!!</p>
    <p style="color:orange">5.- EN FER START DE NOU, CANVIEN LES DADES DE LA TAULA?????????? - LOAD PREVI NECESSARI, DOCUMENTAR..</p>
    <p style="color:blue">6.- INCLUDE DEL Q13.i??? (mascara de signo necesaria)?????</p>
    <p style="color:blue">7.- ADJUNTAR CÁLCULO DIVISIÓN Q13/ENTERO.</p>
    <p style="color:yellow">8.- HACE FALTA DIVMOD.h en geotemp.c????</p>
    <p style="color:blue">9.- REVISAR COMENTARIOS.</p>
    <p style="color:orange">10.- Para documentación: Indicar el porqué del movimiento de la opción -c en el makefile a CCFLAGS.</p>
    <p style="color:blue">TO DO: Més proves.</p>
    <p style="color:green">EXTRA: AUNQUE SEA INUTIL PONER -Lp_lib</p>
    <p styke="color:orange">OPTIMIZAR AVANCE FILAS AVGMAXMIN_CITY - HECHO Y JUSTIFICAR !!!!! (mla POR add).</p>
<h3>FASE 3:</h3>
    <p style="color:green">1.- JUSTIFICACIÓN COMENTARIOS PRODUCTO (mismo dilema que en FASE 1/2).</p>
    <p style="color:yellow">2.- ADICION DE MASK_NUM VALIDA EN Q13.i???</p>
    <p style="color:yellow">3.- JUSTIFICAR MAKE_Q13(1.0) /// CALCULAR MAKE_Q13(1.0) << 13. Poner directamente el número calculado o calcular << 13 dentro del código??? PONER CONSTANTE.</p>
    <p style="color:yellow">4.- LIB FONCOMPUS + STARTUP.o en TESTS???</p>
    <p style="color:yellow">5.- DONDE GUARDAMOS LIBQ13.a, EN DIRECTORIO BASE???</p>
    <p style="color:yellow">6.- libQ13.a antes de libfoncompus.a - explicacion????</p>
    <p style="color:yellow">7.- Se puede modificar el Makefile base de la fase 3 o solo añadir cosas???</p>
    <p style="color:blue">8.- Revisar comentarios.</p>
    <p style="color:orange">9.- DOCUMENTAR 12 en Q13!!!.</p>
    <p style="color:yellow">10.- Copiar archivos de cabeceras o llamar desde los archivos de la fase 2?</p>
    <p style="color:orange">11.- Para documentación: Indicar el porqué del movimiento de la opción -c en el makefile a CCFLAGS.</p>
    <p style="color:yellow">12.- Cal provar overflow???</p>
    <p style="color:blue">TO DO: Más pruebas (-0.0?????, USAR MASCARA DE BITS?????)</p>
    <p style="color:blue">Acabar de traduir fases 1 y 2 con nueva librería, hacer Makefile, revisar demo.o</p>
    <p style="color:orange">Documentar el porqué de nrows << 13 (demostración analítica).</p>
    <p style="color:red">ERROR GEOTEMP_LIB.c - Los cálculos y las funciones operan bien, diferenciacion por pocos números, puede ser por la precision???</p>
<h3>FASE EXTRA</h3>
    <p style="color:purple">PROBLEMA EN EL NÚMERO DE ITERACIONES A REALIZAR - REVISAR QUE PASA CON PRUEBA 3</p>

IMPORTANTISIMOOOOO:
        -   JUSTIFICAR smull r1, r2, r0, r3 frente a smull r0, r1, r3, r0  POR EFICIENCIA TEMPORAL/DE EJECUCIÓN PARA FASE 1 (EN FASE 3 PLANTEAR COMPARACIÓN).
        -   Cambiar idioma de cociente y residuo de los comentarios de la fase 2 y 3 (al acceder a la pila para ocupar registros).
        -   Revisar errors típics (avance por matrices???).
        -   Preguntar por implementación de cambio de signo de la división en la segunda fase (en la tercera no hay otra opción).
        -   Uso de máscaras???
        -   PRUEBA DE -0.0 EN FASE 3 !!!!!!!
        -   TST CON MASCARAS!!!!!!
        -   OPTIMIZAR PROCESO CAMBIO DE SIGNO FASE 2 (y div_mod fase 3).

<h2>ESTADO ACTUAL: Subrutinas de la fase 3 acabadas. Realizar pruebas, ensamblar librería de operaciones y adaptar fases 1 y 2 a código</h2>

COMENTAR EN REUNIONES:
