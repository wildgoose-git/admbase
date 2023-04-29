#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершениеОбъединенияСотрудников" Тогда
		Элементы.Список.Обновить();
		Элементы.ЗагружаемыеИмена.Обновить();
	КонецЕсли;

КонецПроцедуры
	

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок	

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если  Не ТекущаяСтрока = Неопределено И ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗначениеОтбора = ТекущаяСтрока;
	Иначе
		ЗначениеОтбора = Неопределено;
	КонецЕсли;
	
	ЭлементыОтбора = ЗагружаемыеИмена.Отбор.Элементы;
	ЭлементыОтбора.Очистить();
	
	ЭлементОтбора = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= ЗначениеОтбора;

КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Объединить(Команда)

	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() < 2 Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Выбрано меньше двух строк";
	    СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивКОбъединению", ВыделенныеСтроки);
	
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаОбъединение",ПараметрыФормы, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


#КонецОбласти 