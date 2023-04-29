#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;

	ПроверкаКоррекностиВводаСотрудников(Отказ,РежимЗаписи);	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаИсходныеДанные.НомерСтроки КАК НомерСтроки,
	|	ТаблицаИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ТаблицаИсходныеДанные.Должность КАК Должность,
	|	ТаблицаИсходныеДанные.Подразделение КАК Подразделение,
	|	ОтражениеСостоянийСотрудников.Дата КАК Период
	|ИЗ
	|	Документ.ОтражениеСостоянийСотрудников.ИсходныеДанные КАК ТаблицаИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтражениеСостоянийСотрудников КАК ОтражениеСостоянийСотрудников
	|		ПО ТаблицаИсходныеДанные.Ссылка = ОтражениеСостоянийСотрудников.Ссылка
	|ГДЕ
	|	ТаблицаИсходныеДанные.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Движения.СостояниеСотрудников.Загрузить(Запрос.Выполнить().Выгрузить());
	Движения.СостояниеСотрудников.Записывать = Истина;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ПроверкаКоррекностиВводаСотрудников(Отказ,РежимЗаписи)
	
	Если Не РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
		 Возврат
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИсходныеДанные",ИсходныеДанные);
	Запрос.Текст = "ВЫБРАТЬ
	|	ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ИсходныеДанные.Должность КАК Должность,
	|	ИсходныеДанные.Подразделение КАК Подразделение,
	|	ИсходныеДанные.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	&ИсходныеДанные КАК ИсходныеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИсходныеДанные.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ЗадвоенныеСтроки
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсходныеДанные.Сотрудник
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИсходныеДанные.НомерСтроки) > 1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходныеДанные.Сотрудник КАК Сотрудник,
	|	ИсходныеДанные.Должность КАК Должность,
	|	ИсходныеДанные.Подразделение КАК Подразделение,
	|	ИсходныеДанные.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗадвоенныеСтроки КАК ЗадвоенныеСтроки
	|		ПО ИсходныеДанные.Сотрудник = ЗадвоенныеСтроки.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	НомерСтроки";
	
	Результат = Запрос.Выполнить();
	Если  Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;

	Выборка = Результат.Выбрать();
	
	Массив = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Массив.Добавить(СтрШаблон("ном. строки %1; %2 %3;  %4",Строка(Выборка.НомерСтроки),
						Строка(Выборка.Сотрудник),
						Строка(Выборка.Должность),
						Строка(Выборка.Подразделение)))
	КонецЦикла;
	
	ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Задвоенные данные у сотрудников%1%2",Символы.ПС,СтрСоединить(Массив,Символы.ПС)),,,,Отказ);

КонецПроцедуры
			 
#КонецОбласти 


#КонецЕсли
