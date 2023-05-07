#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НачалоПериода")  Тогда 
		Объект.Дата = Параметры.НачалоПериода 
	КонецЕсли;
	
	Если Параметры.Свойство("Территория")  Тогда
		Объект.Территория = Параметры.Территория
	КонецЕсли;
            	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимостьКомандЗагрузки();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если  ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
	
		ПроверкаЗадвоенийТекущейЗагрузки(ТекущийОбъект.ИсходныеДанные,Отказ);
	
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновлениеРегистраЗаданий",,ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТерриторияПриИзменении(Элемент)
	УстановитьВидимостьКомандЗагрузки();
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

//@skip-check module-structure-form-event-regions
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗагрузитьCSVРогачево(Команда)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Заголовок = "Выберите файл с данными проходов Рогачево";
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = "Данные проходов Рогачево (*.csv)|*.csv|"; // 
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайлаCSV",ЭтотОбъект,Новый Структура("Территория","Рогачево"));
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьCSVМосква(Команда)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Заголовок = "Выберите файл с данными проходов Москва";
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = "Данные проходов Москва (*.csv)|*.csv|"; // 
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайлаCSV",ЭтотОбъект,Новый Структура("Территория","Москва"));
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЗначениеДатыИзСтроки(Текст)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат '00010101'
	КонецЕсли;
	
	Число 	= Сред(Текст,1,2);
	Месяц 	= Сред(Текст,4,2);
	Год 	= Сред(Текст,7,4);
	
	Возврат  Дата(СтрШаблон("%1%2%3",Год,Месяц,Число));
	
КонецФункции // ЗначениеДатыИзСтроки()

&НаКлиенте
Функция ЗначениеВремяИзСтроки(Знач Текст,Сотрудник)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат '00010101'
	КонецЕсли;
	
	ПозицияПробел = СтрНайти(Текст," ");
	Если Не ПозицияПробел = 0 Тогда
		Текст = Сред(Текст,ПозицияПробел +1)
	КонецЕсли;
	
	ПозицияДвоеточия = СтрНайти(Текст,":");
	
	Часы            = Сред(Текст,1,ПозицияДвоеточия-1);
	Минуты          = Сред(Текст,ПозицияДвоеточия+1,2);
	
	Пока СтрДлина(Часы) < 2 Цикл 
		Часы = СтрШаблон("0%1",Часы);
	КонецЦикла; 
	Пока СтрДлина(Минуты) < 2 Цикл 
		Минуты = СтрШаблон("0%1",Минуты);
	КонецЦикла;
	
	Если Часы = "24" И Минуты = "00" Тогда
		Возврат '00010101235959'	
	КонецЕсли;
	
	ДатаСтрокой = СтрЗаменить("00010101%_%00","%_%",СтрШаблон("%1%2",Часы,Минуты));
		

	Попытка
		Возврат Дата(ДатаСтрокой)
	Исключение
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрШаблон("%1 - ошибка преобразования строки в дату %2",Сотрудник,Текст);
		СообщениеПользователю.Сообщить();
		Возврат '00010101';
	КонецПопытки;

	
КонецФункции // ЗначениеВремяИзСтроки()

&НаКлиенте
Функция ДатуИзСтрокиВремени(Знач Текст,Сотрудник)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат '00010101'
	КонецЕсли;
	
	ПозицияПробел = СтрНайти(Текст," ");
	Если  ПозицияПробел = 0 Тогда
		Возврат '00010101'
	КонецЕсли;
	
	Возврат ЗначениеДатыИзСтроки(Текст);
	
КонецФункции // ЗначениеВремяИзСтроки()

&НаКлиенте
Процедура УстановитьВидимостьКомандЗагрузки()
	
	ВидимостьМосква = Объект.Территория = ПредопределенноеЗначение("Перечисление.Территории.Москва");
	
	Элементы.ИсходныеДанныеЗагрузитьCSVМосква.Видимость = ВидимостьМосква;	
	Элементы.ИсходныеДанныеЗагрузитьCSVРогачево.Видимость = Не ВидимостьМосква;	
	
КонецПроцедуры  // УстановитьВидимостьКомандЗагрузки()

&НаСервере
Процедура ПроверкаЗадвоенийТекущейЗагрузки(ИсходныеДанные,Отказ)
	
	Если  Не ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина)
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущиеДанные",ИсходныеДанные.Выгрузить());
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);

#Область ТекстЗапроса
	Запрос.Текст = "ВЫБРАТЬ
	|	ТекущиеДанные.НомерСтроки КАК НомерСтроки,
	|	ТекущиеДанные.Сотрудник КАК Сотрудник,
	|	ТекущиеДанные.Дата КАК Дата,
	|	ТекущиеДанные.Вход КАК Вход,
	|	ТекущиеДанные.Выход КАК Выход,
	|	ТекущиеДанные.ДатаВыход КАК ДатаВыход,
	|	ТекущиеДанные.Присутствие КАК Присутствие
	|ПОМЕСТИТЬ ТекущиеДанные
	|ИЗ
	|	&ТекущиеДанные КАК ТекущиеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПроходыPercoИсходныеДанные.Ссылка КАК Ссылка,
	|	ПроходыPercoИсходныеДанные.Сотрудник.Наименование КАК СотрудникНаименование
	|ИЗ
	|	Документ.ПроходыPerco.ИсходныеДанные КАК ПроходыPercoИсходныеДанные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеДанные КАК ТекущиеДанные
	|		ПО ПроходыPercoИсходныеДанные.Сотрудник = ТекущиеДанные.Сотрудник
	|			И ПроходыPercoИсходныеДанные.Дата = ТекущиеДанные.Дата
	|			И ПроходыPercoИсходныеДанные.Вход = ТекущиеДанные.Вход
	|			И ПроходыPercoИсходныеДанные.Выход = ТекущиеДанные.Выход
	|			И ПроходыPercoИсходныеДанные.ДатаВыход = ТекущиеДанные.ДатаВыход
	|			И ПроходыPercoИсходныеДанные.Присутствие = ТекущиеДанные.Присутствие
	|ГДЕ
	|	ПроходыPercoИсходныеДанные.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПроходыPercoИсходныеДанные.Сотрудник.Наименование";
#КонецОбласти

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	Отказ = Истина;
	
	Выборка = Результат.Выбрать();
	
	Массив = Новый Массив;
	Пока  Выборка.Следующий() Цикл
		Массив.Добавить(СтрШаблон("По сотруднику %1 данные дублируются в док-те %2",Выборка.СотрудникНаименование,Строка(Выборка.Ссылка)));
	КонецЦикла;
	
	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = СтрСоединить(Массив,Символы.ПС);
	СообщениеПользователю.Сообщить();
	
КонецПроцедуры // ПроверкаЗадвоенийТекущейЗагрузки(ИсходныеДанные,Отказ)

#Область ЗагрузкаCSVРогачево

&НаКлиенте
Процедура ПреобразоватьСтрокуЗаголовковРогачево(МассивОписанийКолонок)
	//Два последних поля удаляю не нужны
	МассивОписанийКолонок.Удалить(МассивОписанийКолонок.ВГраница());
	МассивОписанийКолонок.Удалить(МассивОписанийКолонок.ВГраница());
	
	Граница = МассивОписанийКолонок.ВГраница();
	
	МассивОписанийКолонок[0] = "ТабельныйНомер";
	МассивОписанийКолонок[1] = СокрЛП(МассивОписанийКолонок[1]);
	МассивОписанийКолонок[2] = СокрЛП(МассивОписанийКолонок[2]);
	МассивОписанийКолонок[3] = СокрЛП(МассивОписанийКолонок[3]);
	
	Для Индекс = 4  По Граница  Цикл
		Событие 	= Сред(МассивОписанийКолонок[Индекс],СтрНайти(МассивОписанийКолонок[Индекс],"|")+1);
		Дата 		= ЗначениеДатыИзСтроки(МассивОписанийКолонок[Индекс]);
		МассивОписанийКолонок[Индекс] =  Новый Структура("Дата,Событие",Дата,Событие);
	КонецЦикла; 
	
КонецПроцедуры // ПреобразоватьСтрокуЗаголовковРогачево()

&НаКлиенте
Процедура ЗаполнитьТаблицуЗагрузкиИзМассиваСтрокРогачево(МассивСтрок)

	ВГраница = МассивСтрок.ВГраница();
	//Заполняем таблицы значений
	Для Индекс=1 По ВГраница Цикл
		ДобавитьСтрокиТаблицыЗначенийРогачево(МассивСтрок[Индекс],МассивСтрок[0])
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьДокументИзМассиваСтрок(МассивСтрок)()

&НаКлиенте
Процедура ДобавитьСтрокиТаблицыЗначенийРогачево(Массив,МассивОписаний)

	Граница = МассивОписаний.Вграница();
	Для  Индекс = 4 По Граница Цикл
		
		НоваяСтрока = ТаблицаЗагрузки.Добавить();
		НоваяСтрока.ТабельныйНомер 	= СокрЛП(Массив[0]);
		НоваяСтрока.ФИОСотрудника 	= СокрЛП(Массив[1]);
		НоваяСтрока.Подразделение 	= СокрЛП(Массив[2]);
		НоваяСтрока.Должность 		= СокрЛП(Массив[3]);
		НоваяСтрока.Дата			= МассивОписаний[Индекс].Дата;
		
		НоваяСтрока.Вход			= ЗначениеВремяИзСтроки(СокрЛП(Массив[Индекс]),		НоваяСтрока.ФИОСотрудника);
		НоваяСтрока.Выход			= ЗначениеВремяИзСтроки(СокрЛП(Массив[Индекс+1]),	НоваяСтрока.ФИОСотрудника);
		НоваяСтрока.ДатаВыход		= ДатуИзСтрокиВремени(СокрЛП(Массив[Индекс+1]),		НоваяСтрока.ФИОСотрудника);		
		
		НоваяСтрока.Присутствие		= ЗначениеВремяИзСтроки(СокрЛП(Массив[Индекс+2]),	НоваяСтрока.ФИОСотрудника);		
		
		Индекс = Индекс +2;
		
	КонецЦикла;
	
КонецПроцедуры // ДобавитьСтрокиТаблицЗначений()

#КонецОбласти

#Область ЗагрузкаCSVМосква

&НаКлиенте
Процедура ЗаполнитьТаблицуЗагрузкиИзМассиваСтрокМосква(МассивСтрок)

	  Для  Каждого МассивСтроки Из МассивСтрок Цикл
		
		НоваяСтрока = ТаблицаЗагрузки.Добавить();
		НоваяСтрока.ТабельныйНомер 	= СтрЗаменить(СокрЛП(МассивСтроки[11]),Символ(34),"");
		НоваяСтрока.ФИОСотрудника 	= СтрЗаменить(СокрЛП(МассивСтроки[9]),Символ(34),"");
		НоваяСтрока.Дата			= ЗначениеДатыИзСтроки(СтрЗаменить(МассивСтроки[20],Символ(34),""));
		
	    НоваяСтрока.Вход			= ЗначениеВремяИзСтроки(СтрЗаменить(МассивСтроки[21],Символ(34),""),	НоваяСтрока.ФИОСотрудника);
		НоваяСтрока.Выход			= ЗначениеВремяИзСтроки(СтрЗаменить(МассивСтроки[24],Символ(34),""),	НоваяСтрока.ФИОСотрудника);
		НоваяСтрока.Присутствие		= ЗначениеВремяИзСтроки(СтрЗаменить(МассивСтроки[25],Символ(34),""),	НоваяСтрока.ФИОСотрудника);		
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьТаблицуЗагрузкиИзМассиваСтрокМосква(МассивСтрок)
	
#КонецОбласти

#Область ЗавершениеЗагрузки

&НаКлиенте
Процедура ПослеВыбораФайлаCSV(ВыбранныеФайлы,ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат
	КонецЕсли; 
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	ДополнительныеПараметры.Вставить("ТекстовыйДокумент",ТекстовыйДокумент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНачалаЧтенияФайлаCSV",ЭтотОбъект,ДополнительныеПараметры);

	ТекстовыйДокумент.НачатьЧтение(ОписаниеОповещения,ВыбранныеФайлы[0], ,Символы.ПС);
		
КонецПроцедуры // ПослеВыбораФайлаCSV()

&НаКлиенте
Процедура ПослеНачалаЧтенияФайлаCSV(ДополнительныеПараметры) Экспорт 

	ТаблицаЗагрузки.Очистить();

	ТекстовыйДокумент = ДополнительныеПараметры.ТекстовыйДокумент;
	МассивСтрок = Новый Массив;
	
	Если ДополнительныеПараметры.Территория = "Рогачево" Тогда
		РазделительСтрок = ";"
	Иначе
		РазделительСтрок = ","
	КонецЕсли;
	
	КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	Счетчик = 1;
	Пока Счетчик <= КоличествоСтрок Цикл
		МассивСтрок.Добавить(СтрРазделить(ТекстовыйДокумент.ПолучитьСтроку(Счетчик),
						РазделительСтрок,Истина));	
		Счетчик = Счетчик +1;
	КонецЦикла; 
	
	Если МассивСтрок.Количество() = 0 Тогда
		Возврат
	КонецЕсли; 
	
	//Рогачево
	Если ДополнительныеПараметры.Территория = "Рогачево" Тогда
		ПреобразоватьСтрокуЗаголовковРогачево(МассивСтрок[0]);
		ЗаполнитьТаблицуЗагрузкиИзМассиваСтрокРогачево(МассивСтрок);
	КонецЕсли;
	
	//++Москва
	Если ДополнительныеПараметры.Территория = "Москва" Тогда
		ЗаполнитьТаблицуЗагрузкиИзМассиваСтрокМосква(МассивСтрок);
	КонецЕсли;

	МассивЗагрузки = Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаЗагрузки Цикл
		Структура = КонсолидацияКлиентСервер.ИнициализироватьСтруктуруТаблицыПроходовPERCo();
		ЗаполнитьЗначенияСвойств(Структура,СтрокаТаблицы);
		МассивЗагрузки.Добавить(Структура);
	КонецЦикла;

	ПослеНачалаЧтенияФайлаCSVЗавершение(МассивЗагрузки);
	
	Модифицированность = Истина;
	
КонецПроцедуры // ПослеНачалаЧтенияФайлаCSV()

&НаКлиенте
Процедура ПослеНачалаЧтенияФайлаCSVЗавершение(МассивЗагрузки, МассивОшибок = Неопределено)
	
	Если МассивОшибок = Неопределено Тогда
		МассивОшибок = Новый Массив;
	КонецЕсли;

	ИсходныеДанные = ПолучитьИсходныеДанные(МассивЗагрузки, МассивОшибок);

	Если МассивОшибок.Количество() = 0 Тогда

		Объект.ИсходныеДанные.Очистить();
		Для Каждого ЭлементМассива Из ИсходныеДанные Цикл
			ЗаполнитьЗначенияСвойств(Объект.ИсходныеДанные.Добавить(), ЭлементМассива);
		КонецЦикла;
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыКорректировкаЗагружаемыхДанных", ЭтотОбъект, 
				Новый Структура("МассивЗагрузки",МассивЗагрузки));
				
		ПараметрыФормы = Новый Структура("МассивОшибок", МассивОшибок);
		
		ОткрытьФорму("Обработка.КорректировкаЗагружаемыхДанных.Форма", ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения); 
		
	КонецЕсли;
	
КонецПроцедуры // ПослеНачалаЧтенияФайлаCSVЗавершение()

&НаСервереБезКонтекста
Функция ПолучитьИсходныеДанные(МассивЗагрузки,МассивОшибок)
	Возврат КонсолидацияЗагрузкаДанных.СформироватьИсходныеДанныеПроходыPERCo(МассивЗагрузки,МассивОшибок);
КонецФункции // ПолучитьИсходныеДанные()

&НаКлиенте
Процедура ПослеЗакрытияФормыКорректировкаЗагружаемыхДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПослеНачалаЧтенияФайлаCSVЗавершение(ДополнительныеПараметры.МассивЗагрузки, Результат);
	
КонецПроцедуры // ПослеЗакрытияФормыКорректировкаЗагружаемыхДанных()
	
#КонецОбласти

#КонецОбласти 