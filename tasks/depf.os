#Использовать v8runner
#Использовать cmdline
#Использовать logos
#Использовать 1commands

Перем ВозможныеКоманды;
Перем Лог;
Перем ЭтоWindows;

Процедура ИнициализацияОкружения()

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;

	Лог = Логирование.ПолучитьЛог("oscript.app.vanessa-init");
	УровеньЛога = УровниЛога.Информация;
	РежимРаботы = ПолучитьПеременнуюСреды("RUNNER_ENV");
	Если ЗначениеЗаполнено(РежимРаботы) И РежимРаботы = "debug" Тогда
		УровеньЛога = УровниЛога.Отладка;
	КонецЕсли;
	
	Лог.УстановитьУровень(УровеньЛога);

	ОдинКаталог = "";
	Для каждого Элемент из АргументыКоманднойСтроки Цикл
		ОдинКаталог = Строка(Элемент);
	КонецЦикла;

	УстановитьПеременнуюСреды("RUNNER_IBNAME", "/F./build/ibservice");
	Команда = Новый Команда;
	Команда.УстановитьПравильныйКодВозврата(0);

	Если Не ПустаяСтрока(ОдинКаталог) Тогда
		Если (Элемент) = "./epf" Или "vanessa-behavior.epf" ИЛИ "./build/vanessa-behavior.epf" Тогда
			ШаблонЗапуска = СтрШаблон("oscript ./tools/runner.os decompileepf ./build/%2 %1 --ibname /F./build/ibservice", "./epf", "vanessa-behavior.epf");
		Иначе
			ШаблонЗапуска = СтрШаблон("oscript ./tools/runner.os decompileepf ./build/%1 %1", ОдинКаталог);
		КонецЕсли;
		Лог.Информация(ШаблонЗапуска);
		ЗапуститьИПодождать(ШаблонЗапуска);
	Иначе
		
		МассивПутей = Новый Массив();
		МассивПутей.Добавить("./epf");
		МассивПутей.Добавить("./lib/featurereader");
		МассивПутей.Добавить("./features");
		МассивПутей.Добавить("./vendor");
		МассивПутей.Добавить("./plugins");
		
		Для каждого Элемент из МассивПутей Цикл
			Если (Элемент) = "./epf" Тогда
				ШаблонЗапуска = СтрШаблон("oscript ./tools/runner.os decompileepf ./build/%2 %1 --ibname /F./build/ibservice", Элемент, "vanessa-behavior.epf");
			Иначе
				ШаблонЗапуска = СтрШаблон("oscript ./tools/runner.os decompileepf ./build/%1 %1 --ibname /F./build/ibservice", Элемент);
			КонецЕсли;
			Лог.Информация(ШаблонЗапуска);
			ЗапуститьИПодождать(ШаблонЗапуска);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


Функция ПрочитатьФайлИнформации(Знач ПутьКФайлу)

	Текст = "";
	Файл = Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		Чтение = Новый ЧтениеТекста(Файл.ПолноеИмя);
		Текст = Чтение.Прочитать();
		Чтение.Закрыть();
	Иначе
		Текст = "Информации об ошибке нет";
	КонецЕсли;

	Лог.Отладка("файл информации:
	|"+Текст);
	Возврат Текст;

КонецФункции


Функция ЗначениеПоУмолчанию(value, defValue="")
	res = ?( ЗначениеЗаполнено(value), value, defValue);
	Возврат res;
КонецФункции

Функция ЗапуститьИПодождать(СтрокаЗапуска)
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку();

	Процесс = СоздатьПроцесс(СтрокаЗапуска, "./", Истина, Истина);
	Попытка
		Процесс.Запустить();
	Исключение
		Если ЭтоWindows Тогда
			ШаблонЗапуска = "cmd /c %1";
		Иначе
			ШаблонЗапуска = "sh -c '%1'";
		КонецЕсли;
		Процесс = СоздатьПроцесс(СтрШаблон(ШаблонЗапуска, СтрокаЗапуска), "./", Истина, Истина);
		Процесс.Запустить();
	КонецПопытки;
	ПериодОпросаВМиллисекундах = 1000;
	Если ПериодОпросаВМиллисекундах <> 0 Тогда
		Приостановить(ПериодОпросаВМиллисекундах);
	КонецЕсли;
	Пока НЕ Процесс.Завершен ИЛИ Процесс.ПотокВывода.ЕстьДанные ИЛИ Процесс.ПотокОшибок.ЕстьДанные Цикл
		//Сообщить(""+ ТекущаяДата() + " Завершен:"+Строка(Процесс.Завершен) + Строка(Процесс.ПотокВывода.ЕстьДанные) + Строка(Процесс.ПотокОшибок.ЕстьДанные) );
		Если ПериодОпросаВМиллисекундах <> 0 Тогда
			Приостановить(ПериодОпросаВМиллисекундах);
		КонецЕсли;

		ОчереднаяСтрокаВывода = Процесс.ПотокВывода.Прочитать();
		ОчереднаяСтрокаОшибок = Процесс.ПотокОшибок.Прочитать();

		Если Не ПустаяСтрока(ОчереднаяСтрокаВывода) Тогда
			ОчереднаяСтрокаВывода = СтрЗаменить(ОчереднаяСтрокаВывода, Символы.ВК, "");
			Если ОчереднаяСтрокаВывода <> "" Тогда
				Лог.Информация("%2%1", ОчереднаяСтрокаВывода, Символы.ПС);
				ЗаписьXML.ЗаписатьБезОбработки(ОчереднаяСтрокаВывода);
			КонецЕсли;
		КонецЕсли;

		Если Не ПустаяСтрока(ОчереднаяСтрокаОшибок) Тогда
			ОчереднаяСтрокаОшибок = СтрЗаменить(ОчереднаяСтрокаОшибок, Символы.ВК, "");
			Если ОчереднаяСтрокаОшибок <> "" Тогда
				//Сообщить(ОчереднаяСтрокаОшибок);
				Лог.Информация("%2%1", ОчереднаяСтрокаОшибок, Символы.ПС);
				ЗаписьXML.ЗаписатьБезОбработки(ОчереднаяСтрокаОшибок);
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	ОчереднаяСтрока = СтрЗаменить(Процесс.ПотокВывода.Прочитать(), Символы.ВК, "");
	Лог.Информация("%2%1", ОчереднаяСтрока, Символы.ПС);
	ЗаписьXML.ЗаписатьБезОбработки(ОчереднаяСтрока);
	РезультатРаботыПроцесса = ЗаписьXML.Закрыть();

	Возврат Новый Структура("КодВозврата, Результат", Процесс.КодВозврата, РезультатРаботыПроцесса);

КонецФункции // ЗапуститьИПодождать(СтрокаЗапуска)

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

ИнициализацияОкружения();