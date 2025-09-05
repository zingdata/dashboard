# Dashboard with Size Information - Usage Examples

This document demonstrates how to use the new `DashboardItemBuilderWithSize` functionality that provides access to the actual pixel size information of dashboard items.

## Backward Compatibility

The existing `itemBuilder` parameter continues to work exactly as before:

```dart
Dashboard<ColoredDashboardItem>(
  dashboardItemController: itemController,
  slotCount: 8,
  itemBuilder: (ColoredDashboardItem item) {
    // Original usage - no changes needed
    return Container(
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('Item: ${item.identifier}'),
    );
  },
)
```

## New Enhanced Builder with Size Information

Use the new `itemBuilderWithSize` parameter to access actual pixel dimensions:

```dart
Dashboard<ColoredDashboardItem>(
  dashboardItemController: itemController,
  slotCount: 8,
  itemBuilderWithSize: (ColoredDashboardItem item, ItemCurrentPosition size) {
    // Access to both the item and its actual pixel size
    return Container(
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Item: ${item.identifier}'),
          Text('Size: ${size.width.toInt()}x${size.height.toInt()}'),
          Text('Position: (${size.x.toInt()}, ${size.y.toInt()})'),
          Text('Slots: ${item.layoutData.width}x${item.layoutData.height}'),
        ],
      ),
    );
  },
)
```

## ItemCurrentPosition Properties

The `ItemCurrentPosition` object provides:
- `width`: Actual pixel width of the item
- `height`: Actual pixel height of the item  
- `x`: X position in pixels from dashboard's top-left
- `y`: Y position in pixels from dashboard's top-left
- `endX`: Right edge position (x + width)
- `endY`: Bottom edge position (y + height)

## Accessing Size from DashboardItem

You can also access the current size directly from the item:

```dart
Dashboard<ColoredDashboardItem>(
  dashboardItemController: itemController,
  slotCount: 8,
  itemBuilder: (ColoredDashboardItem item) {
    // Access current size via the item itself
    final currentSize = item.currentSize;
    
    return Container(
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: currentSize != null 
        ? Text('Actual size: ${currentSize.width}x${currentSize.height}')
        : Text('Size not available'),
    );
  },
)
```

## Important Notes

1. **Mutual Exclusivity**: You must provide exactly one of `itemBuilder` or `itemBuilderWithSize` - not both.

2. **Size Availability**: The `ItemCurrentPosition` reflects the actual rendered size after:
   - Slot calculations (based on viewport width and slotCount)
   - Aspect ratio adjustments
   - Spacing considerations (horizontalSpace, verticalSpace)
   - Padding applications

3. **Use Cases**: The size information is particularly useful for:
   - Responsive content that adapts to actual available space
   - Custom drawing/painting operations
   - Dynamic font sizing based on container dimensions
   - Conditional UI rendering based on available space

## Migration Guide

To migrate from the old builder to the new one:

1. Change parameter name from `itemBuilder` to `itemBuilderWithSize`
2. Add the `ItemCurrentPosition size` parameter to your builder function
3. Use the size information as needed in your widget implementation

No other changes are required - all existing Dashboard configuration remains the same.