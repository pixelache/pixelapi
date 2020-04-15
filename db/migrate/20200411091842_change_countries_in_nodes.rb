class ChangeCountriesInNodes < ActiveRecord::Migration[6.0]
  def change
    execute("UPDATE nodes SET country='FR' where country='France'")
    execute("UPDATE nodes SET country='NO' where country='Norway'")
    execute("UPDATE nodes SET country='FI' where country='Finland'")
    execute("UPDATE nodes SET country='IS' where country='Iceland'")
    execute("UPDATE nodes SET country='UK' where country='United Kingdom'")
    change_column :nodes, :country, :string, limit: 2
  end
end
