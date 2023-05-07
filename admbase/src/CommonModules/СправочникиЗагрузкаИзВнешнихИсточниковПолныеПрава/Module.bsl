////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Загрузка справочника сотрудники с таблицей ошибок.
// Записывает подчиненный справочник ЗагружаемыеФИОСотрудников
// Записывает справочник ИсключаемыеИзЗагрузкиДанные
// формирует ТаблицуОшибок
// 
// Параметры:
//  ТаблицаЗначений -ТаблицаЗначений - данные для загрузки
//  ТаблицаОшибок 	- ДанныеФормыКоллекция - ФИО сотрудников для котороых не найдены соотвествия
Процедура ЗагрузкаСправочникаСотрудникиСТаблицейОшибок(ТаблицаЗначений,ТаблицаОшибок) Экспорт 
	
	//1. То что найдено загружается 
	//2. То чего нет помещается в таблицу ошибок 
	//3. Если таблицаОшибок уже сформирована 
	//		Флаг - СоздатьНовый - создаст новые элементы справочника
	//		Флаг - НеЗагружать - Запись в справочник - Исключаемые из загрузки данные
	//		Сотрудник - заполненный - записывает новый элемент подчиненного справочника
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаОшибок",	ТаблицаОшибок);

#Область ОбработкаТаблицыОшибок

#Область ТекстЗапроса
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаОшибок.ФИОСотрудника КАК ФИОСотрудника,
	|	ТаблицаОшибок.Сотрудник,
	|	ТаблицаОшибок.НеЗагружать,
	|	ТаблицаОшибок.СоздатьНовый
	|ПОМЕСТИТЬ ТаблицаОшибок
	|ИЗ
	|	&ТаблицаОшибок КАК ТаблицаОшибок
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФИОСотрудника
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОшибок.Сотрудник,
	|	ТаблицаОшибок.ФИОСотрудника
	|ИЗ
	|	ТаблицаОшибок КАК ТаблицаОшибок
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИсключаемыеИзЗагрузкиДанные КАК ИсключаемыеИзЗагрузкиДанные
	|		ПО ТаблицаОшибок.ФИОСотрудника = ИсключаемыеИзЗагрузкиДанные.Наименование
	|		И ИсключаемыеИзЗагрузкиДанные.ТипЗагружаемыхДанных = ЗНАЧЕНИЕ(Перечисление.ТипыЗагружаемыхДанных.СправочникСотрудники)
	|ГДЕ
	|	ТаблицаОшибок.Сотрудник <> ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
	|	И ИсключаемыеИзЗагрузкиДанные.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОшибок.ФИОСотрудника
	|ИЗ
	|	ТаблицаОшибок КАК ТаблицаОшибок
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИсключаемыеИзЗагрузкиДанные КАК ИсключаемыеИзЗагрузкиДанные
	|		ПО ТаблицаОшибок.ФИОСотрудника = ИсключаемыеИзЗагрузкиДанные.Наименование
	|		И ИсключаемыеИзЗагрузкиДанные.ТипЗагружаемыхДанных = ЗНАЧЕНИЕ(Перечисление.ТипыЗагружаемыхДанных.СправочникСотрудники)
	|ГДЕ
	|	ТаблицаОшибок.СоздатьНовый = ИСТИНА
	|	И ИсключаемыеИзЗагрузкиДанные.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОшибок.ФИОСотрудника
	|ИЗ
	|	ТаблицаОшибок КАК ТаблицаОшибок
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИсключаемыеИзЗагрузкиДанные КАК ИсключаемыеИзЗагрузкиДанные
	|		ПО ТаблицаОшибок.ФИОСотрудника = ИсключаемыеИзЗагрузкиДанные.Наименование
	|		И ИсключаемыеИзЗагрузкиДанные.ТипЗагружаемыхДанных = ЗНАЧЕНИЕ(Перечисление.ТипыЗагружаемыхДанных.СправочникСотрудники)
	|ГДЕ
	|	ИсключаемыеИзЗагрузкиДанные.Ссылка ЕСТЬ NULL";
	
#КонецОбласти

	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[1].Выбрать(); //запись загружаемого ФИО в подчиненный справочник 
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			СправочникФИО = Справочники.ЗагружаемыеФИОСотрудников.СоздатьЭлемент();
			СправочникФИО.Наименование = Выборка.ФИОСотрудника;
			СправочникФИО.Владелец = Выборка.Сотрудник;
			СправочникФИО.Записать();
			
			УдалитьСтрокуТаблицыОшибок(ТаблицаОшибок, Выборка.ФИОСотрудника);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЦикла;

	Выборка = Результат[2].Выбрать(); //запись новых справочников
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			СправочникСотрудник = Справочники.Сотрудники.СоздатьЭлемент();
			СправочникСотрудник.Наименование 	= Выборка.ФИОСотрудника;
			СправочникСотрудник.УстановитьНовыйКод();
			СправочникСотрудник.Записать();

			СправочникЗагрузка = Справочники.ЗагружаемыеФИОСотрудников.СоздатьЭлемент();
			СправочникЗагрузка.Наименование =  Выборка.ФИОСотрудника;
			СправочникЗагрузка.Владелец = СправочникСотрудник.Ссылка;
			СправочникЗагрузка.Записать();
			
			УдалитьСтрокуТаблицыОшибок(ТаблицаОшибок, Выборка.ФИОСотрудника);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
	КонецЦикла;
	
	Выборка = Результат[3].Выбрать(); //запись исключаемых ФИО в справочник ИсключаемыеИзЗагрузкиДанные
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			СправочникФИО = Справочники.ИсключаемыеИзЗагрузкиДанные.СоздатьЭлемент();
			СправочникФИО.Наименование 			= Выборка.ФИОСотрудника;
			СправочникФИО.ТипЗагружаемыхДанных 	= Перечисления.ТипыЗагружаемыхДанных.СправочникСотрудники;
			СправочникФИО.Записать();
			
			УдалитьСтрокуТаблицыОшибок(ТаблицаОшибок, Выборка.ФИОСотрудника);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЦикла;
	
#КонецОбласти
	
	Запрос.УстановитьПараметр("ТаблицаЗначений",	ТаблицаЗначений);

#Область ТекстЗапроса
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника
	|ПОМЕСТИТЬ ТаблицаЗначений
	|ИЗ
	|	&ТаблицаЗначений КАК ТаблицаЗначений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|
	|	ФИОСотрудника
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗагружаемыеФИОСотрудников.Наименование КАК ФИОСотрудника
	|ПОМЕСТИТЬ ЗагружаемыеФИО
	|ИЗ
	|	Справочник.ЗагружаемыеФИОСотрудников КАК ЗагружаемыеФИОСотрудников
	|ГДЕ
	|	ЗагружаемыеФИОСотрудников.Наименование В
	|		(ВЫБРАТЬ
	|			ТаблицаЗначений.ФИОСотрудника
	|		ИЗ
	|			ТаблицаЗначений КАК ТаблицаЗначений)
	|	И ЗагружаемыеФИОСотрудников.ПометкаУдаления = ЛОЖЬ
	|	И ЗагружаемыеФИОСотрудников.НеИспользовать = ЛОЖЬ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФИОСотрудника
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсключаемыеИзЗагрузкиДанные.Наименование
	|Поместить ИсключаемыеДанные
	|ИЗ
	|	Справочник.ИсключаемыеИзЗагрузкиДанные КАК ИсключаемыеИзЗагрузкиДанные
	|ГДЕ
	|	ИсключаемыеИзЗагрузкиДанные.Наименование В
	|		(ВЫБРАТЬ
	|			ТаблицаЗначений.ФИОСотрудника
	|		ИЗ
	|			ТаблицаЗначений КАК ТаблицаЗначений)
	|	И
	|		ИсключаемыеИзЗагрузкиДанные.ТипЗагружаемыхДанных = ЗНАЧЕНИЕ(Перечисление.ТипыЗагружаемыхДанных.СправочникСотрудники)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаЗначений.ФИОСотрудника КАК ФИОСотрудника
	|ИЗ
	|	ТаблицаЗначений КАК ТаблицаЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗагружаемыеФИО КАК ЗагружаемыеФИО
	|		ПО ТаблицаЗначений.ФИОСотрудника = ЗагружаемыеФИО.ФИОСотрудника
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсключаемыеДанные КАК ИсключаемыеДанные
	|		ПО ТаблицаЗначений.ФИОСотрудника = ИсключаемыеДанные.Наименование
	|ГДЕ
	|	ЗагружаемыеФИО.ФИОСотрудника ЕСТЬ NULL
	|	И ИсключаемыеДанные.Наименование ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФИОСотрудника";
#КонецОбласти

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаОшибок.Добавить(),Выборка);		
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗагрузкаСправочникаСотрудникиПоПолю(ТаблицаЗначений) Экспорт 
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТаблицаЗначений",ТаблицаЗначений);
	
#Область ТекстЗапроса

	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаЗначений.ФИОСотрудника КАК Наименование
	|ПОМЕСТИТЬ ТаблицаЗначений
	|ИЗ
	|	&ТаблицаЗначений КАК ТаблицаЗначений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаНаименования.Наименование КАК Наименование,
	|	Сотрудники.ПометкаУдаления КАК ПометкаУдаления,
	|	Сотрудники.Владелец КАК Ссылка,
	|	Сотрудники.Код КАК Код
	|ПОМЕСТИТЬ СправочникСотрудники
	|ИЗ
	|	Справочник.ЗагружаемыеФИОСотрудников КАК ТаблицаНаименования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ТаблицаНаименования.Ссылка = Сотрудники.Ссылка
	|ГДЕ
	|	ТаблицаНаименования.Наименование В
	|			(ВЫБРАТЬ
	|				ТаблицаЗначений.Наименование КАК Наименование
	|			ИЗ
	|				ТаблицаЗначений КАК ТаблицаЗначений)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникСотрудники.Ссылка КАК Ссылка,
	|	СправочникСотрудники.Код КАК Код,
	|	СправочникСотрудники.Наименование КАК Наименование
	|ИЗ
	|	СправочникСотрудники КАК СправочникСотрудники
	|ГДЕ
	|	СправочникСотрудники.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаЗначений.Наименование КАК Наименование
	|ИЗ
	|	ТаблицаЗначений КАК ТаблицаЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ СправочникСотрудники КАК СправочникСотрудники
	|		ПО ТаблицаЗначений.Наименование = СправочникСотрудники.Наименование
	|ГДЕ
	|	СправочникСотрудники.Наименование ЕСТЬ NULL
	|	ИЛИ СправочникСотрудники.ПометкаУдаления 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
#КонецОбласти

	Результат = Запрос.ВыполнитьПакет();
	
	РезультатПометкиУдаления = Результат[Результат.ВГраница()-1];
	Если Не РезультатПометкиУдаления.Пустой() Тогда
		
		МассивСообщений = Новый Массив;
		МассивСообщений.Добавить("Загружаются сотрудники помеченные на удаление");
		МассивСообщений.Добавить("~~~~~~~~~~~~~~~");
		
		Выборка = РезультатПометкиУдаления.Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивСообщений.Добавить(СтрШаблон("Код %1; %2",Выборка.Код,Выборка.Наименование));
		КонецЦикла;
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрСоединить(МассивСообщений,Символы.ПС);
		СообщениеПользователю.Сообщить();
		
	КонецЕсли;
	
	Если Результат[Результат.ВГраница()].Пустой() Тогда
		Возврат
	КонецЕсли;
	
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			СправочникСотрудник = Справочники.Сотрудники.СоздатьЭлемент();
			СправочникСотрудник.Наименование 	= Выборка.Наименование;
			СправочникСотрудник.УстановитьНовыйКод();
			СправочникСотрудник.Записать();
			
			СправочникЗагрузка = Справочники.ЗагружаемыеФИОСотрудников.СоздатьЭлемент();
			СправочникЗагрузка.Наименование =  Выборка.Наименование;
			СправочникЗагрузка.Владелец = СправочникСотрудник.Ссылка;
			СправочникЗагрузка.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗагрузкаСправочникаПоНаменованию(ТаблицаЗначений,ИмяСправочника,ИмяПоляТаблицы) Экспорт 

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗначений",ТаблицаЗначений);

#Область ТекстЗапроса

	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаЗначений.ИмяПоляТаблицы КАК Наименование
	|ПОМЕСТИТЬ ТаблицаЗначений
	|ИЗ
	|	&ТаблицаЗначений КАК ТаблицаЗначений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИмяСправочника.Наименование КАК Наименование
	|ПОМЕСТИТЬ ИмяСправочника
	|ИЗ
	|	Справочник.ИмяСправочника КАК ИмяСправочника
	|ГДЕ
	|	ИмяСправочника.Наименование В
	|			(ВЫБРАТЬ
	|				ТаблицаЗначений.Наименование КАК Наименование
	|			ИЗ
	|				ТаблицаЗначений КАК ТаблицаЗначений)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаЗначений.Наименование КАК Наименование
	|ИЗ
	|	ТаблицаЗначений КАК ТаблицаЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИмяСправочника КАК ИмяСправочника
	|		ПО ТаблицаЗначений.Наименование = ИмяСправочника.Наименование
	|ГДЕ
	|	ИмяСправочника.Наименование ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
#КонецОбласти
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"ИмяСправочника",ИмяСправочника);
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"ИмяПоляТаблицы",ИмяПоляТаблицы);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
	
		СправочникОбъект = Справочники[ИмяСправочника].СоздатьЭлемент();
		СправочникОбъект.Наименование = Выборка.Наименование;
		СправочникОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьСтрокуТаблицыОшибок(ТаблицаОшибок,ФИОСотрудника)
	
	НайденныеСтроки = ТаблицаОшибок.НайтиСтроки(Новый Структура("ФИОСотрудника",ФИОСотрудника ));
	Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
		ТаблицаОшибок.Удалить(СтрокаТаблицы)
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

