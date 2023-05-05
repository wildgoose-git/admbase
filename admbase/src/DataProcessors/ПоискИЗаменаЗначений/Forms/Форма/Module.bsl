////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных
// Переменные для работы обработки в фоновом режиме
&НаКлиенте
Перем ПараметрыОбработчикаОжидания, ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//d.b.(
	Если Параметры.Свойство("ЧтоЗаменять") Тогда
		ЗаменяемыеЗначения.Добавить().ЧтоЗаменять= Параметры.ЧтоЗаменять		
	КонецЕсли;
	//d.b.)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаменяемыеЗначения

&НаКлиенте
Процедура ЗаменяемыеЗначенияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНайденныеСсылки
 
&НаКлиенте
Процедура НайденныеСсылкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

#Если ВебКлиент Тогда

#Иначе
		ОткрытьЗначение(Элемент.ТекущиеДанные.Данные);
		СтандартнаяОбработка = Ложь;
#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
// Процедура вызывается при нажатии кнопки "НайтиСсылки" командной панели
// табличного поля "ЗаменяемыеЗначения". 
// Выполняет поиск объектов, содержащих указанные ссылки.
//
&НаКлиенте
Процедура КоманднаяПанельЗаменяемыеЗначенияНайтиСсылки(Команда)

	МассивЗаменяемых = Новый Массив;

	Для Каждого ЗаменитьСтрока Из ЗаменяемыеЗначения Цикл
		Если ЗаменитьСтрока.Пометка Тогда
			МассивЗаменяемых.Добавить(ЗаменитьСтрока.ЧтоЗаменять);
		КонецЕсли;
	КонецЦикла;

	Если МассивЗаменяемых.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбрано ни одного значения для поиска!'"));
		Возврат;
	КонецЕсли;

	КоманднаяПанельЗаменяемыеЗначенияНайтиСсылкиСервер(МассивЗаменяемых);
		
	КоманднаяПанельНайденныеСсылкиВключитьВсе("");
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельЗаменяемыеЗначенияПоменятьМестами(Команда)
	
	ВыделенныеСтроки = Элементы.ЗаменяемыеЗначения.ВыделенныеСтроки;
	
	Для Каждого НомерСтроки Из ВыделенныеСтроки Цикл
		
		ВыделеннаяСтрока = ЗаменяемыеЗначения.НайтиПоИдентификатору(НомерСтроки);
		ЧтоЗаменять						= ВыделеннаяСтрока.ЧтоЗаменять;
		ВыделеннаяСтрока.ЧтоЗаменять	= ВыделеннаяСтрока.НаЧтоЗаменять;
		ВыделеннаяСтрока.НаЧтоЗаменять	= ЧтоЗаменять;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельНайденныеСсылкиВыполнитьЗамену(Команда)
	
	ЗаданиеВыполнено = ВыполнитьЗаменуСервер();	
	Если ЗаданиеВыполнено Тогда
		ПоказатьВсеСообщения(ИдентификаторЗадания, УникальныйИдентификатор); // В случае работы в клиент-серверном режиме
		ЗаменаВыполнена = ПолучитьИзВременногоХранилища(АдресХранилища); 
		Если ЗаменаВыполнена Тогда
			ПоказатьПредупреждение(Неопределено, НСтр("ru='Замена значений выполнена!'"));
		КонецЕсли;
	Иначе				
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", Новый Структура("ИдентификаторЗадания", ИдентификаторЗадания), ЭтотОбъект);
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельНайденныеСсылкиВключитьВсе(Команда)
	
	Для Каждого СтрокаНайденныеСсылки Из Объект.НайденныеСсылки Цикл
		СтрокаНайденныеСсылки.Включено = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельНайденныеСсылкиВыключитьВсе(Команда)
	
	Для каждого СтрокаНайденныеСсылки Из Объект.НайденныеСсылки Цикл
		СтрокаНайденныеСсылки.Включено = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает объект ОписаниеТипов, содержащий указанный тип.
//
// Параметры:
//  ЗначениеТипа - Строка с именем типа или значение типа Тип.
//  
// Возвращаемое значение:
//  ОписаниеТипов
//
//@skip-check doc-comment-field-type-strict
&НаСервере
Функция вОписаниеТипа(ЗначениеТипа)

	МассивТипов = Новый Массив;
	Если ТипЗнч(ЗначениеТипа) = Тип("Строка") Тогда
		МассивТипов.Добавить(Тип(ЗначениеТипа));
	Иначе
		МассивТипов.Добавить(ЗначениеТипа);
	КонецЕсли; 
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()

// Проверяет, откуда открыта обработка.
// Если обработка открыта как внешний файл, тогда возвращает Истина. 
&НаСервере
Функция ЭтоВнешнийОбъект(ФормаОбъекта)
	
	Возврат (Найти(ФормаОбъекта.ИмяФормы, "Внешн") = 1);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПоказатьВсеСообщения(ИдентификаторЗадания, ИдентификаторФормы)
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		Если Задание <> Неопределено Тогда
			МассивСообщений = Задание.ПолучитьСообщенияПользователю();
			Если МассивСообщений <> Неопределено Тогда
				Для Каждого Сообщение Из МассивСообщений Цикл
					Сообщение.ИдентификаторНазначения = ИдентификаторФормы;
					Сообщение.Сообщить();
				КонецЦикла;
			КонецЕсли;
		КонецЕсли; 
		
	КонецЕсли;

КонецПроцедуры


#Область ВнутренниеПроцедурыИФункции
&НаСервере
Процедура КоманднаяПанельЗаменяемыеЗначенияНайтиСсылкиСервер(МассивЗаменяемых)
	
	//ТаблицаНайденныхСсылок = НайтиПоСсылкам(МассивЗаменяемых);	
	
	ТаблицаНайденныхСсылок = ОбщегоНазначения.МестаИспользования(МассивЗаменяемых);
	
	ТаблицаНайденныхСсылок.Колонки[0].Имя = "Ссылка";
	ТаблицаНайденныхСсылок.Колонки[1].Имя = "Данные";
	ТаблицаНайденныхСсылок.Колонки[2].Имя = "Метаданные";
	
	ТаблицаНайденныхСсылок.Колонки.Добавить("Включено", вОписаниеТипа("Булево"));
	ТаблицаНайденныхСсылок.Колонки.Добавить("ПредставлениеМетаданных", вОписаниеТипа("Строка"));
	ТаблицаНайденныхСсылок.Колонки.Добавить("КлючЗаписиРегистраСведений", вОписаниеТипа("СписокЗначений"));
	
	Для Каждого СтрокаНайденнаяСсылка Из ТаблицаНайденныхСсылок Цикл
				
		СтрокаНайденнаяСсылка.ПредставлениеМетаданных = СтрокаНайденнаяСсылка.Метаданные.ПолноеИмя();
		
		Если Метаданные.РегистрыСведений.Содержит(СтрокаНайденнаяСсылка.Метаданные) Тогда
			Данные = СтрокаНайденнаяСсылка.Данные;
			КлючЗаписи = СтрокаНайденнаяСсылка.КлючЗаписиРегистраСведений;
			КлючЗаписи.Добавить(Данные.Период, "Период");
			КлючЗаписи.Добавить(Данные.Регистратор, "Регистратор");
			Для Каждого Измерение ИЗ СтрокаНайденнаяСсылка.Метаданные.Измерения Цикл
				КлючЗаписи.Добавить(Данные[Измерение.Имя], Измерение.Имя);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Объект.НайденныеСсылки.Загрузить(ТаблицаНайденныхСсылок);

КонецПроцедуры

&НаСервере
Функция ВыполнитьЗаменуСервер()
	
	// Подготовка данных для замены
		                                  
	Заменяемые = Новый Соответствие;
	Для каждого Стр Из ЗаменяемыеЗначения Цикл
		Если Стр.Пометка Тогда
			Заменяемые.Вставить(Стр.ЧтоЗаменять, Стр.НаЧтоЗаменять);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаНайденныеСсылки = Объект.НайденныеСсылки.Выгрузить(Новый Структура("Включено", Истина));
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Ложь, УникальныйИдентификатор);	
	
	Если Заменяемые.Количество() = 0 Или ТаблицаНайденныеСсылки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрано ни одного значения для замены!'"));
		Возврат Истина;
	КонецЕсли;	
	
	// Подготовка параметров запуска процедуры замены
	
	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("ЗаменяемыеЗначения",		Заменяемые);
	ПараметрыОбработки.Вставить("НайденныеСсылки",			ТаблицаНайденныеСсылки);
	ПараметрыОбработки.Вставить("ВыполнятьВТранзакции",		Объект.ВыполнятьВТранзакции);
	ПараметрыОбработки.Вставить("ОтключатьКонтрольЗаписи",	Объект.ОтключатьКонтрольЗаписи);
	ПараметрыОбработки.Вставить("ПояснятьПроцесс",			Объект.ПояснятьПроцесс);


	
	// Запуск замены в зависимости от режима работы
	
	//Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Или ЭтоВнешнийОбъект(ЭтотОбъект) Тогда	
	//TODO: Переделать в дительную операцию	
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ЗаменаВыполнена = ОбработкаОбъект.ВыполнитьЗаменуЭлементов(ПараметрыОбработки);
		АдресХранилища = ПоместитьВоВременноеХранилище(ЗаменаВыполнена, УникальныйИдентификатор);
	
		Возврат Истина;	
		
	//КонецЕсли;			
	
//	Если ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая Тогда
//		ВремяОжидания = 4;
//	Иначе
//		ВремяОжидания = 2;
//	КонецЕсли;
//	
//	ПараметрыЭкспортнойПроцедуры = Новый Массив;
//	ПараметрыЭкспортнойПроцедуры.Добавить(ПараметрыОбработки);
//	ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилища);
//
//	НаименованиеЗадания = НСтр("ru = 'Поиск и замена значений'");
//	
//	Задание = ФоновыеЗадания.Выполнить("ФоновыеЗаданияБухгалтерскийУчет.ПоискИЗаменаЗначений", ПараметрыЭкспортнойПроцедуры, , НаименованиеЗадания);
//	Попытка
//		Задание.ОжидатьЗавершения(ВремяОжидания);
//	Исключение		
//		// Специальная обработка не требуется. Предположительно, исключение вызвано истечением времени ожидания.
//	КонецПопытки;
//	
//	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
//	Возврат ДлительныеОперации.ЗаданиеВыполнено(Задание.УникальныйИдентификатор);		
	
КонецФункции

 &НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка 
		
		Если ПроверитьВыполнениеФоновогоЗаданияНаСервере(ИдентификаторЗадания) Тогда
			
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);			
			ПоказатьВсеСообщения(ИдентификаторЗадания, УникальныйИдентификатор);			
			ЗаменаВыполнена = ПолучитьИзВременногоХранилища(АдресХранилища);
			Если ЗаменаВыполнена Тогда
				ПоказатьПредупреждение(Неопределено, НСтр("ru='Замена значений выполнена!'"));
			КонецЕсли;
			
			Возврат;
			
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ПоказатьВсеСообщения(ИдентификаторЗадания, УникальныйИдентификатор);
		ВызватьИсключение ОписаниеОшибки();
		
	КонецПопытки;	
	
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВыполнениеФоновогоЗаданияНаСервере(ФоновоеЗаданиеИдентификатор)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор);
	
КонецФункции

#КонецОбласти

#КонецОбласти