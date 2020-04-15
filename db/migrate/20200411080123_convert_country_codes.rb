class ConvertCountryCodes < ActiveRecord::Migration[6.0]
  def change
    execute("UPDATE PLACES SET country='AU' where country='Australia'")
    execute("UPDATE PLACES SET country='EE' where country='Estonia'")
    execute("UPDATE PLACES SET country='FI' where country='Finland'")
    execute("UPDATE PLACES SET country='FR' where country='France'")
    execute("UPDATE PLACES SET country='NO' where country='Norway'")
    execute("UPDATE PLACES SET country='UK' where country='United Kingdom'")
    change_column :places, :country, :string, limit: 2
  end
end
