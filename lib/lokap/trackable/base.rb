require 'verbs'
require_relative 'table_utilities'
require_relative 'refinements/verb_string'

using Lokap::VerbString

module Lokap
  module Trackable
    module Base
      include TableUtilities

      def trackable(subject, options={})
        build_trackable(subject, options)
      end

      def build_trackable(name, options={})
        repeatable = options.fetch(:repeatable, false)
        class_name = trackable_class_name(options[:class_name])
        event      = options[:event] || name
        table_name = trackable_table_name(options[:class_name])

        instance_eval do
          has_many :activities, class_name: class_name, as: :reference

          define_method(:activity?) do |event|
            activities.where(event: event).first
          end

          define_method(:activity_by?) do |event, actor=Thread.current[:current_user] |
            activities.where(actor: actor, event: event).first
          end
        end

        verb = name.to_s.split('_').first
        past_tense_verb = verb.to_s.verb.conjugate(tense: :past, aspect: :perfective)
        past_tense = [past_tense_verb, name.to_s.split('_')[1..-1]].flatten.join('_')

        scope past_tense, -> { joins(:activities).where(["event = ?", event]) }

        # Clean up this mess.
        scope "un#{past_tense}", -> {
          joins("LEFT OUTER JOIN #{table_name} " <<
            "ON #{table_name}.reference_id = #{arel_table.name}.id " <<
            "AND #{table_name}.event = '#{event}'")
            .where("#{table_name}.event" => nil) }

        define_method("#{past_tense}?") do
          !!activity?(event)
        end

        define_method("un#{past_tense}?") do
          !activity?(event)
        end

        define_method("#{name}!") do |actor=Thread.current[:current_user], data=nil|
          activity = activities.find_or_create_by(actor: actor, event: event, data: data)
          activity.touch and return activity
        end

        define_method("un#{name}!") do |data=nil|
          activities.where(event: event)&.destroy_all
        end

        # Not necessary at the moment
        #
        # define_method("#{name.to_s}!") do |actor, data={}|
        #   return if repeatable && activity_by?(actor, name, event, table_name)
        #   send(table_name.to_sym).create(
        #     actor_id: actor.id, actor_type: actor.class.to_s, event: event, data: data)
        # end
        #
        # define_method("un#{name.to_s}!") do |actor|
        #   return unless activity_by?(actor, name, event, table_name)
        #   send(table_name.to_sym).where(
        #     actor_id: actor.id, actor_type: actor.class, event: event).first.destroy
        # end
      end
    end
  end
end
