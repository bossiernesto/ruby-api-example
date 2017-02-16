require_relative 'scoped_accesors'

module Promise
  include ::ScopedAccessors

  class Promise

  end


  class Callback
    attr_accesor :source
    protected_attr_accesor :on_fulfill, :on_reject, :next


    def initialize(on_fullfill, on_reject, next_promise)

      self.on_fulfill= on_fullfill if on_fullfill.is_a? Proc
      self.on_reject= on_reject if on_reject.is_a? Proc

      self.next = next_promise
      next_promise.source = self
    end

    def fulfill(value)
      self.call_block(self.on_fulfill, value)
    end

    def reject(reason)
      self.call_block(self.on_reject, reason)
    end

    protected

    def call_block(block, *params)

      begin
        self.next_promise.fulfill(block.call(params))
      rescue => e
        self.next_promise.reject e
      end


    end

  end
end