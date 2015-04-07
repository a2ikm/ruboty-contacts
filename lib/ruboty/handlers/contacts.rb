module Ruboty
  module Handlers
    class Contacts < Base
      NAMESPACE = "contacts"

      on(/add contact (?<name>[^ ]+) (?<number>\+\d+)/, name: "add", description: "Add a new contact")

      on(/delete contact (?<name>[^ ]+)/, name: "delete", description: "Delete a contact")

      on(/list contacts\z/, name: "list", description: "List all contacts")

      def add(message)
        contact = create(message)
        message.reply("New contact \"#{contact.name}\" created")
      end

      def delete(message)
        name = message[:name]
        if contacts.has_key?(name)
          contacts.delete(name)
          message.reply("Contact \"#{name}\" deleted")
        else
          message.reply("Contact \"#{name}\" does not exist")
        end
      end

      def list(message)
        message.reply(summary, code: true)
      end

      private

      def contacts
        robot.brain.data[NAMESPACE] ||= {}
      end

      def create(message)
        contact = Ruboty::Contacts::Contact.new(
          name:   message[:name],
          number: message[:number]
        )
        contacts[contact.name] = contact.to_hash
        contact
      end

      def summary
        if contacts.empty?
          empty_message
        else
          contact_descriptions
        end
      end

      def empty_message
        "No contacts"
      end

      def contact_descriptions
        contacts.values.map do |attributes|
          Ruboty::Contacts::Contact.new(attributes).description
        end.join("\n")
      end
    end
  end
end