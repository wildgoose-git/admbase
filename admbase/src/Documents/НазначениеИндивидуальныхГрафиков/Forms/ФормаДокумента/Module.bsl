#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	            	
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

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СхемаРабочегоВремени",ТекущийОбъект.СхемаРабочегоВремени);
	Запрос.Текст = "ВЫБРАТЬ
	|	СхемыРаботы.РабочееВремяНачало КАК РабочееВремяНачало,
	|	СхемыРаботы.РабочееВремяОкончание КАК РабочееВремяОкончание,
	|	СхемыРаботы.ПерерывНачало КАК ПерерывНачало,
	|	СхемыРаботы.ПерерывОкончание КАК ПерерывОкончание
	|ИЗ
	|	Справочник.СхемыРаботы КАК СхемыРаботы
	|ГДЕ
	|	СхемыРаботы.Ссылка = &СхемаРабочегоВремени";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Для каждого СтрокаКоллекции Из  ТекущийОбъект.ИсходныеДанные Цикл
		ЗаполнитьЗначенияСвойств(СтрокаКоллекции,Выборка)
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновлениеРегистраЗаданий",,ЭтотОбъект);

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
Процедура Подобрать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыПодбора",ЭтотОбъект,Новый Структура);
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаПодбора",,ЭтотОбъект,,,,ОписаниеОповещения);	
	
КонецПроцедуры
	
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ПослеЗакрытияФормыПодбора(РезультатЗакрытия,ДополнительныеПараметры)  Экспорт 

	Если РезультатЗакрытия = Неопределено Тогда
		 Возврат
	КонецЕсли;
	
	Для каждого ЭлементСписка Из РезультатЗакрытия Цикл
	
		 Если Объект.ИсходныеДанные.НайтиСтроки(Новый Структура("Сотрудник",ЭлементСписка.Значение)).Количество() = 0 Тогда
		 
		 	Объект.ИсходныеДанные.Добавить().Сотрудник = ЭлементСписка.Значение
		 
		 КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры // ПослеЗакрытияФормыПодбора()
#КонецОбласти