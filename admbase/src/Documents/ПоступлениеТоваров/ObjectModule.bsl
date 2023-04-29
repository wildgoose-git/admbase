
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
#Область ТекстЗапроса
Запрос.Текст = "ВЫБРАТЬ
|	ПоступлениеТоваров.Контрагент КАК Контрагент,
|	ПоступлениеТоваров.МестоХранения КАК МестоХранения,
|	ПоступлениеТоваровТовары.Номенклатура КАК Номенклатура,
|	ПоступлениеТоваровТовары.Количество КАК Количество,
|	ПоступлениеТоваровТовары.Стоимость КАК Стоимость,
|	ПоступлениеТоваров.Дата КАК Период,
|	ПоступлениеТоваровТовары.НомерСтроки КАК НомерСтроки,
|	ПоступлениеТоваровТовары.Цена КАК Цена
|ПОМЕСТИТЬ ПоступившиеТовары
|ИЗ
|	Документ.ПоступлениеТоваров.Товары КАК ПоступлениеТоваровТовары
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
|		ПО ПоступлениеТоваровТовары.Ссылка = ПоступлениеТоваров.Ссылка
|ГДЕ
|	ПоступлениеТоваровТовары.Ссылка = &Ссылка
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ПоступившиеТовары.Период КАК Период,
|	ПоступившиеТовары.Контрагент КАК Поставщик,
|	ПоступившиеТовары.Номенклатура КАК Номенклатура,
|	ПоступившиеТовары.Количество КАК Количество,
|	ПоступившиеТовары.Стоимость КАК Стоимость
|ИЗ
|	ПоступившиеТовары КАК ПоступившиеТовары
|
|УПОРЯДОЧИТЬ ПО
|	ПоступившиеТовары.НомерСтроки
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ПоступившиеТовары.Период КАК Период,
|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
|	ПоступившиеТовары.МестоХранения КАК МестоХранения,
|	ПоступившиеТовары.Номенклатура КАК Номенклатура,
|	ПоступившиеТовары.Количество КАК Количество,
|	ПоступившиеТовары.Стоимость КАК Стоимость
|ИЗ
|	ПоступившиеТовары КАК ПоступившиеТовары
|
|УПОРЯДОЧИТЬ ПО
|	ПоступившиеТовары.НомерСтроки
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ПоступившиеТовары.Контрагент КАК Контрагент,
|	ПоступившиеТовары.Номенклатура КАК Номенклатура,
|	ПоступившиеТовары.Период КАК Период,
|	ПоступившиеТовары.Цена КАК Цена
|ИЗ
|	ПоступившиеТовары КАК ПоступившиеТовары
|
|УПОРЯДОЧИТЬ ПО
|	ПоступившиеТовары.НомерСтроки";
	
#КонецОбласти

	Результат = Запрос.ВыполнитьПакет();
	
	Движения.ЗакупкиУПоставщиков.Записывать = Истина;
	
	Выборка = Результат[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Движения.ЗакупкиУПоставщиков.Добавить(),Выборка)
	КонецЦикла;
	
	
	Движения.ОстаткиПродуктовНаСкладах.Записывать = Истина;
	
	Выборка = Результат[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Движения.ОстаткиПродуктовНаСкладах.Добавить(),Выборка)
	КонецЦикла;
	
	Движения.ЦеныПоставщиков.Записывать = Истина;
	
	Выборка = Результат[3].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Движения.ЦеныПоставщиков.Добавить(),Выборка)
	КонецЦикла;

	
КонецПроцедуры

#КонецОбласти	
//СДЕЛАТЬ КОНТРОЛЬ ПРОВЕДЕНИЯ И ОТМЕНЫ ПРОВЕДЕНИЯ
#КонецЕсли