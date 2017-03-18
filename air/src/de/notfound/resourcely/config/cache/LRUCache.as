package de.notfound.resourcely.config.cache
{
	import de.notfound.resourcely.model.CacheEntry;

	import flash.system.System;
	import flash.utils.Dictionary;
	
	/**
	 * Used for internal caching.
	 * @private
	 */
	public class LRUCache
	{
		private var _maxSize : Number;
		private var _size : Number;
		private var _front : DoubleLinkedNode;
		private var _end : DoubleLinkedNode;
		private var _hashMap : Dictionary;

		public function LRUCache(maxSize : Number)
		{
			_maxSize = maxSize;
			trace('_maxSize: ' + (_maxSize));
			_size = 0;
			_hashMap = new Dictionary();
		}

		public function insert(key : String, value : CacheEntry) : void
		{
			var node : DoubleLinkedNode = new DoubleLinkedNode(key, value, null, null);
			node.next = _front;
			if (_front != null)
				_front.prev = node;
			_front = node;

			_hashMap[key] = value;
			changeSize(value.estimatedSize);
		}

		public function getValue(key : String) : CacheEntry
		{
			var node : DoubleLinkedNode = DoubleLinkedNode(_hashMap[key]);
			if (node.prev != null)
			{
				node.prev.next = node.next;
				if (node.next != null)
					node.next.prev = node.prev;
				else
					_end = node.prev;

				node.next = _front;
				_front.prev = node;
				node.prev = null;
				_front = node;
			}

			return node.value;
		}

		public function cleanCache(neededSpace : Number) : void
		{
			var calcFreeSpace : Function = function() : Number
			{
				var freeSpace : Number = isNaN(_maxSize) ? System.freeMemory : _maxSize - _size;
				return freeSpace;
			};

			while (calcFreeSpace() < neededSpace)
			{
				var entry : CacheEntry = removeItem();
				
				if(entry == null)
					break;
					
				entry.clear();
				changeSize(-entry.estimatedSize);
			}
		}

		public function removeItem() : CacheEntry
		{
			var last : DoubleLinkedNode = _end;
			if (last == null)
				return null;

			_end = last.prev;
			if (last.prev != null)
				last.prev.next = null;

			_hashMap[last.key] = null;
			delete _hashMap[last.key];
			last.prev = last.next = null;

			return last.value;
		}

		private function changeSize(delta : Number) : void
		{
			_size = Math.max(0, _size + delta);
		}
	}
}