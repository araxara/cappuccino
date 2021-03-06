
@implementation AKThemeTemplate : CPObject
{
    CPString    _name;
    CPString    _description;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aCoder decodeObjectForKey:@"AKThemeTemplateName"];
        _description = [aCoder decodeObjectForKey:@"AKThemeTemplateDescription"];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_name forKey:@"AKThemeTemplateName"];
    [aCoder encodeObject:_description forKey:@"AKThemeTemplateDescription"];
}

@end

@implementation AKThemeObjectTemplate : CPView
{
    CPString    _label;
    id          _themedObject;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _label = [aCoder decodeObjectForKey:@"AKThemeObjectTemplateLabel"];
        _themedObject = [aCoder decodeObjectForKey:@"AKThemeObjectTemplateThemedObject"];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_label forKey:@"AKThemeObjectTemplateLabel"];
    [aCoder encodeObject:_themedObject forKey:@"AKThemeObjectTemplateThemedObject"];
}

@end

function BKThemeDescriptorClasses()
{
    // Grab Theme Descriptor Classes.
    var themeDescriptorClasses = [];
    
    for (candidate in window)
    {
        var theClass = objj_getClass(candidate),
            theClassName = class_getName(theClass),
            index = theClassName.indexOf("ThemeDescriptor");
        
        if ((index >= 0) && (index === theClassName.length - "ThemeDescriptor".length))
            themeDescriptorClasses.push(theClass);
    }
    
    return themeDescriptorClasses;
}

function BKThemeObjectTemplatesForClass(aClass)
{
    var templates = [],
        methods = class_copyMethodList(aClass.isa),
        count = [methods count];

    while (count--)
    {
        var method = methods[count],
            selector = method_getName(method);
    
        if (selector.indexOf("themed") === 0)
        {
            var impl = method_getImplementation(method),
                object = impl(aClass, selector);
            
            if (object)
            {
                var template = [[AKThemeObjectTemplate alloc] init];

                [template setValue:object forKey:@"themedObject"];
                [template setValue:BKLabelFromIdentifier(selector) forKey:@"label"];
                
                [templates addObject:template];
            }
        }
    }
    
    return templates;
}

function BKLabelFromIdentifier(anIdentifier)
{
    var string = anIdentifier.substr("themed".length);
        index = 0,
        count = string.length,
        label = "",
        lastCapital = null,
        isLeadingCapital = YES;
    
    for (; index < count; ++index)
    {
        var character = string.charAt(index),
            isCapital = /^[A-Z]/.test(character);
        
        if (isCapital)
        {        
            if (!isLeadingCapital)
            {
                if (lastCapital === null)
                    label += ' ' + character.toLowerCase();
                else
                    label += character;
            }
            
            lastCapital = character;
        }
        else
        {
            if (isLeadingCapital && lastCapital !== null)
                label += lastCapital;
                
            label += character;
            
            lastCapital = null;
            isLeadingCapital = NO;
        }
    }
    
    return label;
}

