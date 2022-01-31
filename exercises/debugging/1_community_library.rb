=begin
On line 42 of our code, we intend to display information regarding the books
currently checked in to our community library. Instead, an exception is raised.
Determine what caused this error and fix the code so that the data is displayed
as expected.
=end

class Library
  attr_accessor :address, :phone, :books

  def initialize(address, phone)
    @address = address
    @phone = phone
    @books = []
  end

  def check_in(book)
    books.push(book)
  end

  def display_books
    books.each(&:display_data)
  end
end

class Book
  attr_accessor :title, :author, :isbn

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
  end

  def display_data
    puts "---------------"
    puts "Title: #{title}"
    puts "Author: #{author}"
    puts "ISBN: #{isbn}"
    puts "---------------"
  end
end

community_library = Library.new('123 Main St.', '555-232-5652')
learn_to_program = Book.new('Learn to Program', 'Chris Pine', '978-1934356364')
little_women = Book.new('Little Women', 'Louisa May Alcott', '978-1420951080')
wrinkle_in_time = Book.new('A Wrinkle in Time', 'Madeleine L\'Engle', '978-0312367541')

community_library.check_in(learn_to_program)
community_library.check_in(little_women)
community_library.check_in(wrinkle_in_time)

# community_library.books.display_data
# Currently the code is attempting to call the method `#display_data` upon the
# instance variable `@books`, which references an array object. Instead, we need
# to iterate over the book objects within the array referenced by instance
# variable `@books`, and call `#display_data` upon each `book` object.
# community_library.books.each { |book| book.display_data }

# An even better way to accomplish this would be to implement a method in the
# `Library` class, as shown above, which would allow us to make `@books`
# invisible to the outside, or private, if we needed to.

community_library.display_books
