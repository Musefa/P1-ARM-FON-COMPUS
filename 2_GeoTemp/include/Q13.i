@;----------------------------------------------------------------
@;  Declaració de constants GAS per al tractament de dades 
@;	en format Coma Fixa 1:18:13.
@;----------------------------------------------------------------
@;	pere.millan@urv.cat
@;	santiago.romani@urv.cat
@;	(Març 2021, Març 2022, Març 2023, Març 2024)
@;----------------------------------------------------------------

	@; MÀSCARES per als camps de bits de valors 1:18:13
MASK_SIGN = 0x80000000				@; bit 31:		signe
MASK_INT  = 0x7FFFD000				@; bits 30..13:	part entera
MASK_FRAC =	0x00001FFF				@; bits 12..0:	part fraccionària
