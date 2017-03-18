package de.notfound.resourcely.config.cache
{
	import de.notfound.resourcely.model.CacheEntry;

	/**
	 * Used for internal caching.
	 * @private
	 */
	public class DoubleLinkedNode
	{
		public var key : String;
		public var value : CacheEntry;
		public var prev : DoubleLinkedNode;
		public var next : DoubleLinkedNode;

		public function DoubleLinkedNode(key : String, value : CacheEntry, prev : DoubleLinkedNode, next : DoubleLinkedNode)
		{
			this.next = next;
			this.prev = prev;
			this.value = value;
			this.key = key;
		}
	}
}