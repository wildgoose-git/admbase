///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// АПК:75-выкл проверка ОбменДанными.Загрузка должна быть после записи изменений в журнал.
	ЗаписатьИзмененийВЖурналРегистрации(ЭтотОбъект, Замещение);
	// АПК:75-вкл
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отбор.Пользователь.Использование
	   И Не ДатыЗапретаИзмененияСлужебный.ЭтоАдресатЗапретаИзменения(Отбор.Пользователь.Значение) Тогда
		// Даты запрета загрузки настраиваются отдельно в каждой информационной базе.
		ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// В режиме ОбменДанными.Загрузка необходимо обновлять УИД в константе ВерсияДатЗапретаИзменения,
	// который позволять сеансам определить, что нужно обновить кэш дат запрета изменения в памяти.
	Если ОбменДанными.Загрузка Тогда
		Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
			ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзмененияПриЗагрузкеДанных(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
		ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзменения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьИзмененийВЖурналРегистрации(ЭтотОбъект, Замещение)
	
	Таблица = ЭтотОбъект.Выгрузить();
	Таблица.Колонки.Добавить("ВидИзмененияСтроки", Новый ОписаниеТипов("Число"));
	Таблица.ЗаполнитьЗначения(1, "ВидИзмененияСтроки");
	
	Если Замещение Тогда
		СтарыеЗаписи = РегистрыСведений.ДатыЗапретаИзменения.СоздатьНаборЗаписей();
		Для Каждого ЭлементОтбора Из ЭтотОбъект.Отбор Цикл
			Если ЭлементОтбора.Использование Тогда
				СтарыеЗаписи.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение);
			КонецЕсли;
		КонецЦикла;
		СтарыеЗаписи.Прочитать();
		Для Каждого СтараяЗапись Из СтарыеЗаписи Цикл
			НоваяСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтараяЗапись);
			НоваяСтрока.ВидИзмененияСтроки = -1;
		КонецЦикла;
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.ДатыЗапретаИзменения;
	
	Поля = Новый СписокЗначений;
	ШиринаКолонок = Новый Соответствие;
	ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеРегистра.Измерения.Раздел, 20);
	ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеРегистра.Измерения.Объект, 40);
	ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеРегистра.Измерения.Пользователь, 40);
	ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеРегистра.Ресурсы.ДатаЗапрета, 20);
	ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеРегистра.Реквизиты.ОписаниеДатыЗапрета, 22);
	ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеРегистра.Реквизиты.Комментарий, 20);
	
	СписокПолей = СтрСоединить(Поля.ВыгрузитьЗначения(), ",");
	Таблица.Свернуть(СписокПолей, "ВидИзмененияСтроки");
	
	ДобавленныеСтроки = Таблица.НайтиСтроки(Новый Структура("ВидИзмененияСтроки", 1));
	УдаленныеСтроки = Таблица.НайтиСтроки(Новый Структура("ВидИзмененияСтроки", -1));
	
	Если Не ЗначениеЗаполнено(ДобавленныеСтроки)
	   И Не ЗначениеЗаполнено(УдаленныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = Новый Массив;
	Заголовок.Добавить("");
	Для Каждого Поле Из Поля Цикл
		Заголовок.Добавить(ДополненнаяСтрока(Поле.Представление,
			ШиринаКолонок.Получить(Поле.Значение)));
	КонецЦикла;
	
	СтрокиКомментария = Новый Массив;
	СтрокиКомментария.Добавить(СтрСоединить(Заголовок, " | "));
	
	Если ЗначениеЗаполнено(ДобавленныеСтроки) Тогда
		ДобавитьСтроки(СтрокиКомментария, ДобавленныеСтроки, Поля, ШиринаКолонок, "+");
	КонецЕсли;
	Если ЗначениеЗаполнено(УдаленныеСтроки) Тогда
		ДобавитьСтроки(СтрокиКомментария, УдаленныеСтроки, Поля, ШиринаКолонок, "-");
	КонецЕсли;
	
	Комментарий = СтрСоединить(СтрокиКомментария, Символы.ПС) + Символы.ПС;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Даты запрета.Регистрация изменений'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация, МетаданныеРегистра,
		,
		Комментарий,
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
	
КонецПроцедуры

Процедура ДобавитьПоле(Поля, ШиринаКолонок, МетаданныеПоля, ШиринаКолонки);
	
	Поля.Добавить(МетаданныеПоля.Имя, МетаданныеПоля.Представление());
	ШиринаКолонок.Вставить(МетаданныеПоля.Имя, ШиринаКолонки);
	
КонецПроцедуры

Функция ДополненнаяСтрока(Значение, ШиринаКолонки)
	
	Строка = Строка(Значение);
	ДлинаСтроки = СтрДлина(Строка);
	Если ТипЗнч(ШиринаКолонки) <> Тип("Число")
	 Или ШиринаКолонки <= ДлинаСтроки Тогда
		Возврат Строка;
	КонецЕсли;
	Пробелы = "                                            ";
	Возврат Строка + Лев(Пробелы, ШиринаКолонки - ДлинаСтроки);
	
КонецФункции

Процедура ДобавитьСтроки(СтрокиКомментария, СтрокиТаблицы, Поля, ШиринаКолонок, Операция)
	
	Для Каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
		СтрокаКомментария = Новый Массив;
		Для Каждого Поле Из Поля Цикл
			СтрокаКомментария.Добавить(ДополненнаяСтрока(СтрокаТаблицы[Поле.Значение],
				ШиринаКолонок.Получить(Поле.Значение)));
		КонецЦикла;
		СтрокиКомментария.Добавить(Операция + "| " + СтрСоединить(СтрокаКомментария, " | "));
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли