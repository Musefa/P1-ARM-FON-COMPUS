/*-----------------------------------------------------------------------
|   "geotempData.c":
|		Dades per a ser processades per les rutines definides en
|	"avgmaxmintemp.c", a partir de taules que contenen valors de
|	temperatura per a diferents ciutats del món durant els 12 mesos
|	de l'any.
|	Font: https://en.wikipedia.org/wiki/List_of_cities_by_average_temperature
|------------------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Març 2021, Març 2022, Març 2023, Març 2024)
| -----------------------------------------------------------------------*/

#include "Q13.h"				/* Q13: tipus Coma Fixa 1:18:13 */
#include "geotemp.h"			/* t_cityinfo: tipus amb info. de ciutat */
#include "data.h"				/* defines número de ciutats */			

Q13 tempHNord_2020[NUMCITIESHNORD][12] = {
	{MAKE_Q13(13.4), MAKE_Q13(13.9), MAKE_Q13(15.7), MAKE_Q13(18.5),	// Alexandria
	 MAKE_Q13(21.2), MAKE_Q13(24.3), MAKE_Q13(25.9), MAKE_Q13(26.3),
	 MAKE_Q13(25.1), MAKE_Q13(22.0), MAKE_Q13(18.7), MAKE_Q13(14.9)},
	{MAKE_Q13(2.2), MAKE_Q13(3.5), MAKE_Q13(5.8), MAKE_Q13(7.5),		// Andorra la Vella
	 MAKE_Q13(11.5), MAKE_Q13(15.4), MAKE_Q13(18.8), MAKE_Q13(18.5),
	 MAKE_Q13(14.9), MAKE_Q13(10.3), MAKE_Q13(5.7), MAKE_Q13(3.0)},
	{MAKE_Q13(-3.1), MAKE_Q13(0.3), MAKE_Q13(6.7), MAKE_Q13(14.8),		// Beijing
	 MAKE_Q13(20.8), MAKE_Q13(24.9), MAKE_Q13(26.7), MAKE_Q13(25.5),
	 MAKE_Q13(20.8), MAKE_Q13(13.7), MAKE_Q13(5.0), MAKE_Q13(-0.9)},
	{MAKE_Q13(-7.1), MAKE_Q13(-5.4), MAKE_Q13(-1.6), MAKE_Q13(4.6),		// Calgary
	 MAKE_Q13(9.7), MAKE_Q13(13.7), MAKE_Q13(16.5), MAKE_Q13(15.8),
	 MAKE_Q13(11.0), MAKE_Q13(5.2), MAKE_Q13(-2.4), MAKE_Q13(-6.8)},
	{MAKE_Q13(-24.8), MAKE_Q13(-25.4), MAKE_Q13(-22.1), MAKE_Q13(-17.2),// Dikson
	 MAKE_Q13(-7.8), MAKE_Q13(0.4), MAKE_Q13(4.9), MAKE_Q13(5.5),
	 MAKE_Q13(1.6), MAKE_Q13(-7.5), MAKE_Q13(-17.5), MAKE_Q13(-22.9)},
	{MAKE_Q13(25.1), MAKE_Q13(25.7), MAKE_Q13(27.0), MAKE_Q13(28.7),	// Djibouti
	 MAKE_Q13(31.0), MAKE_Q13(34.2), MAKE_Q13(36.4), MAKE_Q13(36.0),
	 MAKE_Q13(33.1), MAKE_Q13(29.3), MAKE_Q13(26.9), MAKE_Q13(25.4)},
	{MAKE_Q13(78.4), MAKE_Q13(79.0), MAKE_Q13(79.9), MAKE_Q13(81.7),	// George Town
	 MAKE_Q13(83.3), MAKE_Q13(84.6), MAKE_Q13(85.3), MAKE_Q13(85.5),
	 MAKE_Q13(84.7), MAKE_Q13(83.3), MAKE_Q13(81.5), MAKE_Q13(79.2)},
	{MAKE_Q13(28.8), MAKE_Q13(33.5), MAKE_Q13(44.2), MAKE_Q13(54.8),	// Kansas City
	 MAKE_Q13(64.5), MAKE_Q13(73.5), MAKE_Q13(78.3), MAKE_Q13(77.0),
	 MAKE_Q13(68.1), MAKE_Q13(56.3), MAKE_Q13(43.6), MAKE_Q13(31.4)},
	{MAKE_Q13(4.6), MAKE_Q13(5.1), MAKE_Q13(8.4), MAKE_Q13(14.2),		// Kyoto
	 MAKE_Q13(19.0), MAKE_Q13(23.0), MAKE_Q13(26.8), MAKE_Q13(28.2),
	 MAKE_Q13(24.1), MAKE_Q13(17.8), MAKE_Q13(12.1), MAKE_Q13(7.0)},
	{MAKE_Q13(17.4), MAKE_Q13(18.1), MAKE_Q13(19.7), MAKE_Q13(22.1),	// La Paz
	 MAKE_Q13(24.5), MAKE_Q13(27.1), MAKE_Q13(29.7), MAKE_Q13(30.2),
	 MAKE_Q13(29.3), MAKE_Q13(26.2), MAKE_Q13(22.0), MAKE_Q13(18.6)},
	{MAKE_Q13(41.3), MAKE_Q13(45.5), MAKE_Q13(54.0), MAKE_Q13(63.0),	// Memphis
	 MAKE_Q13(71.7), MAKE_Q13(79.6), MAKE_Q13(82.7), MAKE_Q13(82.1),
	 MAKE_Q13(75.2), MAKE_Q13(64.1), MAKE_Q13(53.2), MAKE_Q13(43.6)},
	{MAKE_Q13(13.8), MAKE_Q13(16.5), MAKE_Q13(22.1), MAKE_Q13(28.7),	// New Delhi
	 MAKE_Q13(32.8), MAKE_Q13(34.0), MAKE_Q13(30.9), MAKE_Q13(29.7),
	 MAKE_Q13(29.0), MAKE_Q13(26.1), MAKE_Q13(20.5), MAKE_Q13(15.3)},
	{MAKE_Q13(10.6), MAKE_Q13(10.6), MAKE_Q13(13.1), MAKE_Q13(17.1),	// Nicosia
	 MAKE_Q13(22.3), MAKE_Q13(26.9), MAKE_Q13(29.7), MAKE_Q13(29.4),
	 MAKE_Q13(26.2), MAKE_Q13(22.3), MAKE_Q13(16.3), MAKE_Q13(12.0)},
	{MAKE_Q13(16.0), MAKE_Q13(18.2), MAKE_Q13(23.1), MAKE_Q13(27.9),	// Reggane
	 MAKE_Q13(32.2), MAKE_Q13(36.4), MAKE_Q13(39.8), MAKE_Q13(38.4),
	 MAKE_Q13(35.5), MAKE_Q13(29.2), MAKE_Q13(22.0), MAKE_Q13(17.8)},
	{MAKE_Q13(77.6), MAKE_Q13(77.9), MAKE_Q13(78.9), MAKE_Q13(80.3),	// San Juan
	 MAKE_Q13(81.9), MAKE_Q13(83.3), MAKE_Q13(83.4), MAKE_Q13(83.7),
	 MAKE_Q13(83.5), MAKE_Q13(82.6), MAKE_Q13(80.6), MAKE_Q13(76.7)},
	{MAKE_Q13(60.6), MAKE_Q13(63.2), MAKE_Q13(67.1), MAKE_Q13(71.7),	// Tampa
	 MAKE_Q13(78.2), MAKE_Q13(82.0), MAKE_Q13(82.8), MAKE_Q13(83.0),
	 MAKE_Q13(81.5), MAKE_Q13(76.0), MAKE_Q13(69.0), MAKE_Q13(63.0)},
	{MAKE_Q13(-21.6), MAKE_Q13(-16.6), MAKE_Q13(-7.4), MAKE_Q13(2.0),	// Ulaanbaatar
	 MAKE_Q13(10.1), MAKE_Q13(15.7), MAKE_Q13(18.2), MAKE_Q13(16.0),
	 MAKE_Q13(9.6), MAKE_Q13(0.5), MAKE_Q13(-11.9), MAKE_Q13(-19.0)},
	{MAKE_Q13(-38.6), MAKE_Q13(-33.8), MAKE_Q13(-20.1), MAKE_Q13(-4.8),	// Yakutsk
	 MAKE_Q13(7.5), MAKE_Q13(16.4), MAKE_Q13(19.5), MAKE_Q13(15.2),
	 MAKE_Q13(6.1), MAKE_Q13(-7.8), MAKE_Q13(-27.0), MAKE_Q13(-37.6)}
	};


t_cityinfo info_HNord[NUMCITIESHNORD] = {
	{"Alexandria", 'C'},				// Egypt
	{"Andorra la Vella", 'C'},			// Andorra
	{"Beijing", 'C'},					// China
	{"Calgary", 'C'},					// Canada
	{"Dikson", 'C'},					// Russia
	{"Djibouti", 'C'},					// Djibouti
	{"George Town", 'F'},				// Cayman Islands
	{"Kansas City", 'F'},				// USA
	{"Kyoto", 'C'},						// Japan
	{"La Paz", 'C'},					// Mexico
	{"Memphis", 'F'},					// USA
	{"New Delhi", 'C'},					// India
	{"Nicosia", 'C'},					// Cyprus
	{"Reggane", 'C'},					// Argelia
	{"San Juan", 'F'},					// Puerto Rico
	{"Tampa", 'F'},						// USA
	{"Ulaanbaatar", 'C'},				// Mongolia
	{"Yakutsk", 'C'}					// Russia
};	


Q13 tempHSud_2020[NUMCITIESHSUD][12] = {
	{MAKE_Q13(23.2), MAKE_Q13(23.3), MAKE_Q13(20.9), MAKE_Q13(17.6),	// Adelaide
	 MAKE_Q13(13.5), MAKE_Q13(12.1), MAKE_Q13(11.4), MAKE_Q13(12.4),
	 MAKE_Q13(14.4), MAKE_Q13(16.7), MAKE_Q13(19.7), MAKE_Q13(21.3)},
	{MAKE_Q13(15.0), MAKE_Q13(14.8), MAKE_Q13(11.9), MAKE_Q13(7.9),		// Bariloche
	 MAKE_Q13(4.9), MAKE_Q13(2.9), MAKE_Q13(2.1), MAKE_Q13(3.0),
	 MAKE_Q13(5.1), MAKE_Q13(8.0), MAKE_Q13(10.8), MAKE_Q13(13.5)},
	{MAKE_Q13(20.6), MAKE_Q13(20.1), MAKE_Q13(17.6), MAKE_Q13(13.4),	// Canberra
	 MAKE_Q13(9.4), MAKE_Q13(6.7), MAKE_Q13(5.7), MAKE_Q13(7.0),
	 MAKE_Q13(9.8), MAKE_Q13(12.8), MAKE_Q13(15.8), MAKE_Q13(18.8)},
	{MAKE_Q13(27.7), MAKE_Q13(27.6), MAKE_Q13(27.4), MAKE_Q13(27.4),	// Dili
	 MAKE_Q13(27.0), MAKE_Q13(26.8), MAKE_Q13(25.5), MAKE_Q13(25.1),
	 MAKE_Q13(25.4), MAKE_Q13(26.0), MAKE_Q13(27.2), MAKE_Q13(27.4)},
	{MAKE_Q13(20.8), MAKE_Q13(20.8), MAKE_Q13(20.0), MAKE_Q13(18.9),	// Fianarantsoa
	 MAKE_Q13(16.7), MAKE_Q13(14.5), MAKE_Q13(14.0), MAKE_Q13(14.4),
	 MAKE_Q13(16.2), MAKE_Q13(18.3), MAKE_Q13(19.7), MAKE_Q13(20.4)},
	{MAKE_Q13(25.9), MAKE_Q13(25.3), MAKE_Q13(24.1), MAKE_Q13(21.2),	// Ghanzi
	 MAKE_Q13(17.6), MAKE_Q13(14.3), MAKE_Q13(14.1), MAKE_Q13(17.1),
	 MAKE_Q13(21.5), MAKE_Q13(24.6), MAKE_Q13(25.7), MAKE_Q13(26.1)},
	{MAKE_Q13(23.3), MAKE_Q13(23.7), MAKE_Q13(23.1), MAKE_Q13(21.9),	// Hanga Roa
	 MAKE_Q13(20.1), MAKE_Q13(18.9), MAKE_Q13(18.0), MAKE_Q13(17.9),
	 MAKE_Q13(18.3), MAKE_Q13(19.0), MAKE_Q13(20.4), MAKE_Q13(21.8)},
	{MAKE_Q13(21.0), MAKE_Q13(20.7), MAKE_Q13(20.3), MAKE_Q13(18.8),	// Harare
	 MAKE_Q13(16.1), MAKE_Q13(13.7), MAKE_Q13(13.4), MAKE_Q13(15.5),
	 MAKE_Q13(18.6), MAKE_Q13(20.8), MAKE_Q13(21.2), MAKE_Q13(20.9)},
	{MAKE_Q13(27.1), MAKE_Q13(26.9), MAKE_Q13(27.1), MAKE_Q13(27.3),	// Jayapura
	 MAKE_Q13(27.2), MAKE_Q13(26.9), MAKE_Q13(26.4), MAKE_Q13(26.6),
	 MAKE_Q13(26.9), MAKE_Q13(27.2), MAKE_Q13(27.3), MAKE_Q13(27.0)},
	{MAKE_Q13(19.5), MAKE_Q13(19.0), MAKE_Q13(18.0), MAKE_Q13(15.3),	// Johannesburg
	 MAKE_Q13(12.6), MAKE_Q13(9.6), MAKE_Q13(10.0), MAKE_Q13(12.5),
	 MAKE_Q13(15.9), MAKE_Q13(17.1), MAKE_Q13(17.9), MAKE_Q13(19.0)},
	{MAKE_Q13(15.2), MAKE_Q13(14.8), MAKE_Q13(12.4), MAKE_Q13(9.2),		// Lake Tekapo
	 MAKE_Q13(5.9), MAKE_Q13(2.6), MAKE_Q13(1.4), MAKE_Q13(3.6),
	 MAKE_Q13(6.5), MAKE_Q13(8.8), MAKE_Q13(11.1), MAKE_Q13(13.2)},
	{MAKE_Q13(23.0), MAKE_Q13(22.5), MAKE_Q13(20.6), MAKE_Q13(17.2),	// Montevideo
	 MAKE_Q13(14.0), MAKE_Q13(11.1), MAKE_Q13(10.9), MAKE_Q13(11.7),
	 MAKE_Q13(13.4), MAKE_Q13(16.0), MAKE_Q13(18.6), MAKE_Q13(21.3)},
	{MAKE_Q13(27.4), MAKE_Q13(27.3), MAKE_Q13(27.1), MAKE_Q13(27.0),	// Port Moresby
	 MAKE_Q13(26.9), MAKE_Q13(26.1), MAKE_Q13(25.7), MAKE_Q13(26.1),
	 MAKE_Q13(26.5), MAKE_Q13(27.5), MAKE_Q13(27.6), MAKE_Q13(27.8)},
	{MAKE_Q13(10.8), MAKE_Q13(10.3), MAKE_Q13(8.5), MAKE_Q13(6.2),		// Punta Arenas
	 MAKE_Q13(3.7), MAKE_Q13(1.5), MAKE_Q13(1.4), MAKE_Q13(2.3),
	 MAKE_Q13(4.2), MAKE_Q13(6.4), MAKE_Q13(8.4), MAKE_Q13(9.9)},
	{MAKE_Q13(26.3), MAKE_Q13(26.6), MAKE_Q13(26.0), MAKE_Q13(24.4),	// Rio de Janeiro
	 MAKE_Q13(22.8), MAKE_Q13(21.8), MAKE_Q13(21.3), MAKE_Q13(21.8),
	 MAKE_Q13(22.2), MAKE_Q13(22.9), MAKE_Q13(24.0), MAKE_Q13(25.3)},
	{MAKE_Q13(9.5), MAKE_Q13(8.9), MAKE_Q13(8.1), MAKE_Q13(6.1),		// Stanley
	 MAKE_Q13(3.9), MAKE_Q13(2.2), MAKE_Q13(1.9), MAKE_Q13(2.2),
	 MAKE_Q13(3.9), MAKE_Q13(5.3), MAKE_Q13(7.0), MAKE_Q13(8.1)},
	{MAKE_Q13(16.2), MAKE_Q13(15.7), MAKE_Q13(15.8), MAKE_Q13(15.5),	// Sucre
	 MAKE_Q13(14.9), MAKE_Q13(13.8), MAKE_Q13(13.9), MAKE_Q13(14.9),
	 MAKE_Q13(16.2), MAKE_Q13(16.9), MAKE_Q13(17.3), MAKE_Q13(16.7)},
	{MAKE_Q13(9.6), MAKE_Q13(9.3), MAKE_Q13(7.7), MAKE_Q13(5.7),		// Ushuaia
	 MAKE_Q13(3.2), MAKE_Q13(1.7), MAKE_Q13(1.3), MAKE_Q13(2.2),
	 MAKE_Q13(4.1), MAKE_Q13(6.2), MAKE_Q13(7.8), MAKE_Q13(9.1)},
	{MAKE_Q13(16.9), MAKE_Q13(17.2), MAKE_Q13(15.8), MAKE_Q13(13.7),	// Wellington
	 MAKE_Q13(11.7), MAKE_Q13(9.7), MAKE_Q13(8.9), MAKE_Q13(9.4),
	 MAKE_Q13(10.8), MAKE_Q13(12.0), MAKE_Q13(13.5), MAKE_Q13(15.4)}
};


t_cityinfo info_HSud[NUMCITIESHSUD] = {
	{"Adelaide", 'C'},					// Australia
	{"Bariloche", 'C'},					// Argentina
	{"Canberra", 'C'},					// Australia
	{"Dili", 'C'},						// East Timor
	{"Fianarantsoa", 'C'},				// Madagascar
	{"Ghanzi", 'C'},					// Botswana
	{"Hanga Roa", 'C'},					// Chile
	{"Harare", 'C'},					// Zimbabwe
	{"Jayapura", 'C'},					// Indonesia
	{"Johannesburg", 'C'},				// South Africa
	{"Lake Tekapo", 'C'},				// New Zealand
	{"Montevideo", 'C'},				// Uruguay
	{"Port Moresby", 'C'},				// Papua New Guinea
	{"Punta Arenas", 'C'},				// Chile
	{"Rio de Janeiro", 'C'},			// Brazil
	{"Stanley", 'C'},					// Falkland Islands
	{"Sucre", 'C'},						// Bolivia
	{"Ushuaia", 'C'},					// Argentina
	{"Wellington", 'C'}					// New Zealand
};

