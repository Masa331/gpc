# Gpc

This gem is to parse bank statements in special Czech bank statement format ABO(files with .gpc extension)

## Installation

    $ gem install gpc

## Usage

```ruby
data = File.read('statement.gpc')
statements = Gpc.parse(data)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gpc.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Notes

[ČS abo](http://www.csas.cz/banka/content/inet/internet/cs/ABO_format.pdf)  
[GoPay](https://help.gopay.com/cs/tema/mam-platebni-branu/chci-vyuctovat/jak-nastavim-vyuctovani/jak-nastavim-vypis-pohybu-z-gopay-obchodniho-uctu)
