#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//1. Разделяем данные на две таблицы  (Прогулы и Неявки по причинам)
//2. Из таблицы отгулы вытесняем даты таблицей с неявками по причинам
//3. Объединяем все в таблицу движений

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка",		Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	ОтклоненияERP.Дата КАК Дата,
	|	ТаблицаИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ТаблицаИсходныеДанные.ДатаНачала КАК ДатаНачала,
	|	ТаблицаИсходныеДанные.ТипДокумента КАК ТипДокумента,
	|	ТаблицаИсходныеДанные.Номер КАК НомерДокументаERP,
	|	ТаблицаИсходныеДанные.ДатаДокумента КАК ДатаДокументаERP,
	|	ТаблицаИсходныеДанные.НомерСтроки КАК СтрокаДокумента,
	|	ТипыДокументов.Наименование КАК ТипДокументаНаименование,
	|	ВЫБОР
	|		КОГДА ТаблицаИсходныеДанные.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА РАЗНОСТЬДАТ(ТаблицаИсходныеДанные.ДатаНачала, КОНЕЦПЕРИОДА(ТаблицаИсходныеДанные.ДатаНачала, МЕСЯЦ), ДЕНЬ)
	|		ИНАЧЕ РАЗНОСТЬДАТ(ТаблицаИсходныеДанные.ДатаНачала, ТаблицаИсходныеДанные.ДатаОкончания, ДЕНЬ)
	|	КОНЕЦ КАК РазностьДат
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	Документ.ОтклоненияERP.ИсходныеДанные КАК ТаблицаИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтклоненияERP КАК ОтклоненияERP
	|		ПО ТаблицаИсходныеДанные.Ссылка = ОтклоненияERP.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыДокументов КАК ТипыДокументов
	|		ПО ТаблицаИсходныеДанные.ТипДокумента = ТипыДокументов.Ссылка
	|ГДЕ
	|	ТаблицаИсходныеДанные.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходныеДанные.Дата КАК Дата,
	|	ИсходныеДанные.ДатаНачала КАК ДатаНачала,
	|	ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ИсходныеДанные.ТипДокумента КАК ТипДокумента,
	|	ИсходныеДанные.НомерДокументаERP КАК НомерДокументаERP,
	|	ИсходныеДанные.ДатаДокументаERP КАК ДатаДокументаERP,
	|	ИсходныеДанные.СтрокаДокумента КАК СтрокаДокумента,
	|	ИсходныеДанные.ТипДокументаНаименование КАК ТипДокументаНаименование,
	|	ИсходныеДанные.РазностьДат КАК РазностьДат
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|ГДЕ
	|	ИсходныеДанные.ТипДокументаНаименование <> ""Отсутствие (болезнь, прогул, неявка)""";
	
	
	
	//Заполняем таблицу документально подтвержденных отсутствий
	ТаблицаДвижений = ИнициализироватьТаблицуЗначений();
	ЗаполнитьТаблицуДвиженийБезПрогулов(Запрос.Выполнить().Выбрать(),ТаблицаДвижений);
	
	//Заполняем таблицу прогулов
	Запрос.Текст = "ВЫБРАТЬ
	|	ИсходныеДанные.Дата КАК Дата,
	|	ИсходныеДанные.ДатаНачала КАК ДатаНачала,
	|	ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ИсходныеДанные.ТипДокумента КАК ТипДокумента,
	|	ИсходныеДанные.НомерДокументаERP КАК НомерДокументаERP,
	|	ИсходныеДанные.ДатаДокументаERP КАК ДатаДокументаERP,
	|	ИсходныеДанные.СтрокаДокумента КАК СтрокаДокумента,
	|	ИсходныеДанные.ТипДокументаНаименование КАК ТипДокументаНаименование,
	|	ИсходныеДанные.РазностьДат КАК РазностьДат
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|ГДЕ
	|	ИсходныеДанные.ТипДокументаНаименование = ""Отсутствие (болезнь, прогул, неявка)""";
		
	ТаблицаПрогулов = ИнициализироватьТаблицуЗначений();
	ЗаполнитьТаблицуДвиженийБезПрогулов(Запрос.Выполнить().Выбрать(),ТаблицаПрогулов);
	
	
	//Заполнение таблицы движений регистра
	Запрос.Текст = ТекстЗапросаТаблицыДвижений();
	Запрос.УстановитьПараметр("ТаблицаДвижений",ТаблицаДвижений);
	Запрос.УстановитьПараметр("ТаблицаПрогулов",ТаблицаПрогулов);
	
	
	Движения.УчетРабочегоВремениСотрудников.Загрузить(Запрос.Выполнить().Выгрузить());
	Движения.УчетРабочегоВремениСотрудников.Записывать = Истина;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
	     Возврат;
	КонецЕсли;
	
	ЗаданияРасчета  = Перечисления.ЗаданияРасчета.ЗагрузкаДокументовERP;
	КонсолидацияРегистрЗаданий.ЗаписатьПервичныеДанныеВРегистрЗаданий(Отказ,ЗаданияРасчета,Ссылка,Дата,Проведен,ПометкаУдаления);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуДвиженийБезПрогулов(Выборка,ТаблицаДвижений)

	Пока Выборка.Следующий() Цикл
		
		Для Счетчик = 0 По Выборка.РазностьДат Цикл
			
			НовоеДвижение = ТаблицаДвижений.Добавить();
			
			ЗаполнитьЗначенияСвойств(НовоеДвижение,Выборка);
			НовоеДвижение.Дата 			= Выборка.ДатаНачала + (86400 * Счетчик);
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

Функция ТекстЗапросаТаблицыДвижений()

	Возврат "ВЫБРАТЬ
	|	ТаблицаДвижений.Сотрудник КАК Сотрудник,
	|	ТаблицаДвижений.Дата КАК Дата,
	|	ТаблицаДвижений.СтрокаДокумента КАК СтрокаДокумента,
	|	ТаблицаДвижений.ТипДокумента КАК ТипДокумента,
	|	ТаблицаДвижений.НомерДокументаERP КАК НомерДокументаERP,
	|	ТаблицаДвижений.ДатаДокументаERP КАК ДатаДокументаERP,
	|	0 КАК Приоритет
	|ПОМЕСТИТЬ ТаблицаДвижений
	|ИЗ
	|	&ТаблицаДвижений КАК ТаблицаДвижений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПрогулов.Сотрудник КАК Сотрудник,
	|	ТаблицаПрогулов.Дата КАК Дата,
	|	ТаблицаПрогулов.СтрокаДокумента КАК СтрокаДокумента,
	|	ТаблицаПрогулов.ТипДокумента КАК ТипДокумента,
	|	ТаблицаПрогулов.НомерДокументаERP КАК НомерДокументаERP,
	|	ТаблицаПрогулов.ДатаДокументаERP КАК ДатаДокументаERP,
	|	1 КАК Приоритет
	|ПОМЕСТИТЬ ТаблицаПрогулов
	|ИЗ
	|	&ТаблицаПрогулов КАК ТаблицаПрогулов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДвижений.Сотрудник КАК Сотрудник,
	|	ТаблицаДвижений.Дата КАК Дата,
	|	ТаблицаДвижений.Приоритет КАК Приоритет
	|ПОМЕСТИТЬ Приоритеты
	|ИЗ
	|	ТаблицаДвижений КАК ТаблицаДвижений
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаПрогулов.Сотрудник,
	|	ТаблицаПрогулов.Дата,
	|	ТаблицаПрогулов.Приоритет
	|ИЗ
	|	ТаблицаПрогулов КАК ТаблицаПрогулов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Приоритеты.Сотрудник КАК Сотрудник,
	|	Приоритеты.Дата КАК Дата,
	|	МИНИМУМ(Приоритеты.Приоритет) КАК Приоритет
	|ПОМЕСТИТЬ Отсекающая
	|ИЗ
	|	Приоритеты КАК Приоритеты
	|
	|СГРУППИРОВАТЬ ПО
	|	Приоритеты.Сотрудник,
	|	Приоритеты.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Ссылка КАК ДокументДвижения,
	|	ТаблицаДвижений.Сотрудник КАК Сотрудник,
	|	ТаблицаДвижений.Дата КАК Дата,
	|	ТаблицаДвижений.СтрокаДокумента КАК СтрокаДокумента,
	|	ТаблицаДвижений.ТипДокумента КАК ТипДокумента,
	|	ТаблицаДвижений.НомерДокументаERP КАК НомерДокументаERP,
	|	ТаблицаДвижений.ДатаДокументаERP КАК ДатаДокументаERP,
	|	ТаблицаДвижений.Приоритет КАК Приоритет
	|ИЗ
	|	ТаблицаДвижений КАК ТаблицаДвижений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Отсекающая КАК Отсекающая
	|		ПО ТаблицаДвижений.Сотрудник = Отсекающая.Сотрудник
	|			И ТаблицаДвижений.Дата = Отсекающая.Дата
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Ссылка,
	|	ТаблицаПрогулов.Сотрудник,
	|	ТаблицаПрогулов.Дата,
	|	ТаблицаПрогулов.СтрокаДокумента,
	|	ТаблицаПрогулов.ТипДокумента,
	|	ТаблицаПрогулов.НомерДокументаERP,
	|	ТаблицаПрогулов.ДатаДокументаERP,
	|	ТаблицаПрогулов.Приоритет
	|ИЗ
	|	ТаблицаПрогулов КАК ТаблицаПрогулов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Отсекающая КАК Отсекающая
	|		ПО ТаблицаПрогулов.Сотрудник = Отсекающая.Сотрудник
	|			И ТаблицаПрогулов.Дата = Отсекающая.Дата
	|			И ТаблицаПрогулов.Приоритет = Отсекающая.Приоритет
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Дата";
		

КонецФункции // ТекстЗапросаТаблицыДвижений()

Функция ИнициализироватьТаблицуЗначений()

	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("Сотрудник",Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаЗначений.Колонки.Добавить("Дата",новый ОписаниеТипов("Дата"));
	ТаблицаЗначений.Колонки.Добавить("СтрокаДокумента",новый ОписаниеТипов("Число"));
	
	ТаблицаЗначений.Колонки.Добавить("ТипДокумента",новый ОписаниеТипов("СправочникСсылка.ТипыДокументов"));
	ТаблицаЗначений.Колонки.Добавить("НомерДокументаERP",новый ОписаниеТипов("Строка"));
	ТаблицаЗначений.Колонки.Добавить("ДатаДокументаERP",новый ОписаниеТипов("Дата"));
	
	
	Возврат ТаблицаЗначений;
	
КонецФункции // ИнициализироватьТаблицуЗначений()
	
#КонецОбласти 

#КонецЕсли