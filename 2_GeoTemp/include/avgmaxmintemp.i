@;---------------------------------------------------------------------
@; Declaració de desplaçaments (offsets) de camps d'estructures
@;---------------------------------------------------------------------
@;	pere.millan@urv.cat
@;	santiago.romani@urv.cat
@;	(Abril 2021)
@;---------------------------------------------------------------------


  	@; Estructura 't_maxmin' (veure fitxer 'avgmaxmintemp.h')
MM_TMINC = 0	@; Offset del camp temperatura mínima, en graus Celsius
MM_TMAXC = 4	@; Offset del camp temperatura màxima, en graus Celsius
MM_TMINF = 8	@; Offset del camp temperatura mínima, en graus Fahrenheit
MM_TMAXF = 12	@; Offset del camp temperatura màxima, en graus Fahrenheit
MM_IDMIN = 16	@; Offset del camp índex temperatura mínima
MM_IDMAX = 18	@; Offset del camp índex temperatura màxima
MM_SIZE  = 20	@; Número de bytes que ocupa l'estructura 't_maxmin'
