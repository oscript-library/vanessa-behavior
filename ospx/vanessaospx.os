#Использовать asserts
#Использовать logos
#Использовать 1commands

Функция ПутьВанесса() Экспорт

	ФайлИсточника = Новый Файл(ТекущийСценарий().Источник);
	Возврат Новый Файл(ОбъединитьПути(ФайлИсточника.Путь, "..", "vanessa-behavior.epf")).ПолноеИмя;

КонецФункции //ПутьВанесса()

Функция КаталогИнструментов() Экспорт

	ФайлИсточника = Новый Файл(ТекущийСценарий().Источник);
	Возврат Новый Файл(ОбъединитьПути(ФайлИсточника.Путь, "..")).ПолноеИмя;

КонецФункции //КаталогИнструментов()

Function PathVanessa() Export

	return ПутьВанесса();
	
EndFunction // PathVanessa()

Function InstrumentsPath() Export
	
		return КаталогИнструментов();
		
EndFunction // InstrumentsPath()
	