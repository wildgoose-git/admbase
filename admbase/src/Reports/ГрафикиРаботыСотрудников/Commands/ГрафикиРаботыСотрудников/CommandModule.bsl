
//@skip-check module-structure-method-in-regions
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму("Отчет.ГрафикиРаботыСотрудников.Форма",
				ПараметрыФормы, 
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
